//
//  FF.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import Foundation
import Cocoa
import Quartz

class FF: NSObject, ObservableObject, QLPreviewPanelDataSource, QLPreviewPanelDelegate {
    
    static let shared = FF()
    
    static let fm = FileManager.default
    
    @Published var currentFolder: Folder {
        didSet {
            currentFolder.fetchContents {
                self.selectedPath = self.currentFolder.contents?.first
            }
            canGoUp = currentFolder.url.path != "/"
        }
    }
    @Published var selectedPath: Path?
    
    @Published var canGoUp: Bool = true
    
    var quickLookURL: URL?
    
    typealias Frequency = [URL: Int]
    var frequency: Frequency! {
        didSet {
            do {
                try setFrequency(frequency)
            } catch {
                print("Frequency didSet Error:", error)
            }
        }
    }
    
    enum FFError: Error {
        case frequency(String)
    }
        
    override init() {
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        currentFolder = Folder(url, at: -1)
        
        super.init()

        frequency = try! getFrequency()
        
    }
    
    func didAppear() {
        currentFolder.fetchContents {
            self.selectedPath = self.currentFolder.contents?.first
        }
    }
    
    // MARK: - Navigation
    
    func enter(path: Path) {
        if let file = path as? File {
            open(file: file)
        } else if let folder = path as? Folder {
            navigate(to: folder)
        }
    }
    
    func navigate(to folder: Folder) {
        currentFolder = folder
        incrementFrequency(path: folder)
    }
    
    func incrementFrequency(path: Path) {
        path.frequencyCount += 1
        incrementFrequency(url: path.url)
        currentFolder.sortContents()
    }
    
    func incrementFrequency(url: URL) {
        if frequency[url] == nil {
            frequency[url] = 1
        } else {
            frequency[url]! += 1
        }
    }
    
    func goUp() {
        guard canGoUp else { return }
        let url: URL = currentFolder.url.deletingLastPathComponent()
        currentFolder = Folder(url, at: FF.frequencyCount(for: url))
        incrementFrequency(path: currentFolder)
    }
    
    // MARK: - Frequency
    
    // TODO: - Switch to file storage.
    
    static func frequencyCount(for url: URL) -> Int {
        shared.frequency[url] ?? 0
    }
    
    func getFrequency() throws -> Frequency {
        guard let json: String = UserDefaults.standard.string(forKey: "frequent-finder-frequency") else { return [:] }
        guard let data: Data = json.data(using: .utf8) else {
            throw FFError.frequency("Get Data Failed")
        }
        let frequency: Frequency = try JSONDecoder().decode(Frequency.self, from: data)
        return frequency
    }
    
    func setFrequency(_ frequency: Frequency) throws {
        let data: Data = try JSONEncoder().encode(frequency)
        guard let json: String = String(data: data, encoding: .utf8) else {
            throw FFError.frequency("Set Json Failed")
        }
        UserDefaults.standard.set(json, forKey: "frequent-finder-frequency")
    }
    
    // MARK: - Util
    
    static func isFolder(url: URL) -> Bool {
        // TODO: - Improve this.
        !url.lastPathComponent.contains(".")
//        var isDirectory: ObjCBool = true
//        return FF.fm.fileExists(atPath: url.path, isDirectory: &isDirectory)
    }
    
    static func exists(url: URL) -> Bool {
        fm.fileExists(atPath: url.path)
    }
    
    // MARK: - Access
    
    func open(file: File) {
        shell("open", file.url.path)
        incrementFrequency(path: file)
    }
    
    func showInFinder(path: Path) {
        if let folder = path as? Folder {
            folder.fetchContents {
                guard let firstSubPath: Path = folder.contents?.first else { return }
                NSWorkspace.shared.activateFileViewerSelecting([firstSubPath.url])
            }
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([path.url])
        }
        incrementFrequency(path: path)
    }
    
    func showInTerminal(folder: Folder) {
//        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Terminal") else { return }
//        print(folder.url.path)
//        let configuration = NSWorkspace.OpenConfiguration()
//        configuration.arguments = [folder.url.path]
//        NSWorkspace.shared.openApplication(at: url,
//                                           configuration: configuration,
//                                           completionHandler: nil)
        shell("open", "-a", "Terminal", folder.url.path)
        incrementFrequency(path: folder)
    }
    
    func quickLook(file: File) {
        quickLookURL = file.url
        if let sharedPanel = QLPreviewPanel.shared() {
            sharedPanel.delegate = self
            sharedPanel.dataSource = self
            sharedPanel.makeKeyAndOrderFront(self)
        }
        incrementFrequency(path: file)
    }
    
    // MARK: - QuickLook Delegates

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return 1
    }

    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        quickLookURL! as QLPreviewItem
    }
    
    // MARK: - Keys
    
    func keyUp() {
        move(by: -1)
    }
    
    func keyDown() {
        move(by: 1)
    }
    
    func keyEnter() {
        guard let path: Path = selectedPath else { return }
        enter(path: path)
    }
    
    func keyBack() {
        goUp()
    }
    
    func keySpace() {
        if let file: File = selectedPath as? File {
            quickLook(file: file)
        }
    }
    
    func keyF() {
        guard let path: Path = selectedPath else { return }
        showInFinder(path: path)
    }
    
    func keyT() {
        guard let folder: Folder = selectedPath as? Folder else { return }
        showInTerminal(folder: folder)
    }
    
    // MARK: - Move
    
    func move(by increment: Int) {
        guard let path: Path = selectedPath else { return }
        guard let paths: [Path] = currentFolder.contents else { return }
        guard let oldIndex: Int = paths.firstIndex(where: { $0.url == path.url }) else { return }
        let newIndex: Int = oldIndex + increment
        guard newIndex >= 0 && newIndex < paths.count else { return }
        selectedPath = paths[newIndex]
    }
    
    // MARK: - Icon
    
    static func icon(for file: File) -> NSImage? {
        let fileType: String = file.url.pathExtension
        if ["png", "jpg"].contains(fileType.lowercased()) {
            return image(for: file.url)
        }
        return NSWorkspace.shared.icon(forFileType: fileType)
    }
    
    static func image(for url: URL) -> NSImage? {
        NSImage(contentsOf: url)
    }
    
}
