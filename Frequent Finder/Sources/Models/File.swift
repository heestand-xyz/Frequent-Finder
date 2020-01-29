//
//  File.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import Foundation

struct File: Path {
    var id: URL { url }
    let url: URL
    var name: String { url.lastPathComponent }    
    let depth: Int
    init(_ url: URL, depth: Int = 0) {
        guard FF.exists(url: url) else { fatalError("url dose not exist") }
        guard !FF.isFolder(url: url) else { fatalError("url is not a file") }
        self.url = url
        self.depth = depth
        log()
    }
    func log() {
        let padding: String = .init(repeating: " ", count: depth)
        print(padding + url.path)
    }
}
