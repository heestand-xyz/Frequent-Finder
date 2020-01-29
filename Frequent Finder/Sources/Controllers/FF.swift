//
//  FF.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import Foundation
import Cocoa

class FF: ObservableObject {
    
    static let fm = FileManager.default
    
    @Published var currentFolder: Folder {
        didSet {
            currentFolder.fetchContents()
            canGoUp = currentFolder.url.path != "/"
        }
    }
    
    @Published var canGoUp: Bool = true
        
    init() {
        currentFolder = Folder(URL(fileURLWithPath: "/Users/hexagons/Documents"))
    }
    
    func goUp() {
        guard canGoUp else { return }
        currentFolder = Folder(currentFolder.url.deletingLastPathComponent())
    }
    
    func select(url: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
    
    static func isFolder(url: URL) -> Bool {
        !url.lastPathComponent.contains(".")
//        var isDirectory: ObjCBool = true
//        return FF.fm.fileExists(atPath: url.path, isDirectory: &isDirectory)
    }
    
    static func exists(url: URL) -> Bool {
        fm.fileExists(atPath: url.path)
    }
    
}
