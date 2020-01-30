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
            currentFolder.fetchContents()
            canGoUp = currentFolder.url.path != "/"
        }
    }
    
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
    
    // MARK: - Navigation
    
    func navigate(to folder: Folder) {
        currentFolder = folder
        incrementFrequency(url: folder.url)
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
        incrementFrequency(url: file.url)
    }
    
    func showInFinder(path: Path) {
        if let folder = path as? Folder {
            folder.fetchContents()
            guard let firstSubPath: Path = folder.contents?.first else { return }
            NSWorkspace.shared.activateFileViewerSelecting([firstSubPath.url])
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([path.url])
        }
        incrementFrequency(url: path.url)
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
        incrementFrequency(url: folder.url)
    }
    
    func quickLook(file: File) {
        quickLookURL = file.url
        if let sharedPanel = QLPreviewPanel.shared() {
            sharedPanel.delegate = self
            sharedPanel.dataSource = self
            sharedPanel.makeKeyAndOrderFront(self)
        }
        incrementFrequency(url: file.url)
    }
    
    // MARK: - QuickLook Delegates

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return 1
    }

    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        quickLookURL! as QLPreviewItem
    }
    
}

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}
