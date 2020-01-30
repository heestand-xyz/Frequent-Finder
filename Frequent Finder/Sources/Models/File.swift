//
//  File.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import Cocoa

struct File: Path {
    var id: URL { url }
    let url: URL
    var name: String { url.lastPathComponent }
    var depth: Int { url.path.filter({ $0 == "/" }).count }
    let frequencyCount: Int
    var icon: NSImage?
    init(_ url: URL, at frequencyCount: Int) {
        guard FF.exists(url: url) else { fatalError("url dose not exist") }
        guard !FF.isFolder(url: url) else { fatalError("url is not a file") }
        self.url = url
        self.frequencyCount = frequencyCount
        icon = FF.icon(for: self)
        log()
    }
    func log() {
        let padding: String = .init(repeating: " ", count: depth)
        print(padding + url.path)
    }
}
