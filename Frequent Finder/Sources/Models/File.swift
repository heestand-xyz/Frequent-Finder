//
//  File.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import Cocoa

class File: Path {
    var icon: NSImage?
    override init(_ url: URL, at frequencyCount: Int) {
        guard FF.exists(url: url) else { fatalError("url dose not exist") }
        guard !FF.isFolder(url: url) else { fatalError("url is not a file") }
        super.init(url, at: frequencyCount)
        icon = FF.icon(for: self)
    }
}
