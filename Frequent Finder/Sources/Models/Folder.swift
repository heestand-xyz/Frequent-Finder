//
//  Folder.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import Foundation

class Folder: Path, ObservableObject {
    var id: URL { url }
    let url: URL
    var name: String { url.lastPathComponent }
    let depth: Int
    @Published var contents: [Path]?
    init(_ url: URL, depth: Int = 0) {
        guard FF.exists(url: url) else { fatalError("url dose not exist") }
        guard FF.isFolder(url: url) else { fatalError("url is not a folder") }
        self.url = url
        self.depth = depth
        log()
    }
    func fetchContents() {
        contents = getContents()
        sortContents()
    }
    func sortContents() {
        contents = contents?.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }
    func getContents() -> [Path]? {
        do {
            let paths: [String] = try FF.fm.contentsOfDirectory(atPath: url.path)
            let filtered: [String] = paths.filter({ $0.first != "." })
            let urls: [URL] = filtered.map({ url.appendingPathComponent($0) })
            let files: [Path] = urls.map({ url -> Path in
                FF.isFolder(url: url) ? Folder(url, depth: depth + 1) : File(url, depth: depth + 1)
            })
            return files
        } catch {
            print("FF Folder:", url, "Error:", error)
            return nil
        }
    }
    func log() {
        let padding: String = .init(repeating: " ", count: depth)
        print(padding + url.path)
    }
}
