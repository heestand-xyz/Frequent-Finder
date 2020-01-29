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
    var depth: Int { url.path.filter({ $0 == "/" }).count }
    let frequencyCount: Int
    @Published var contents: [Path]?
    init(_ url: URL, at frequencyCount: Int) {
        guard FF.exists(url: url) else { fatalError("url dose not exist") }
        guard FF.isFolder(url: url) else { fatalError("url is not a folder") }
        self.url = url
        self.frequencyCount = frequencyCount
        log()
    }
    func fetchContents() {
        contents = getContents()
        sortContents()
    }
    func sortContents() {
        contents = contents?.sorted(by: { pathA, pathB -> Bool in
            pathA.frequencyCount > pathB.frequencyCount
        })
    }
    func getContents() -> [Path]? {
        do {
            let paths: [String] = try FF.fm.contentsOfDirectory(atPath: url.path)
            let filtered: [String] = paths.filter({ $0.first != "." })
            let urls: [URL] = filtered.map({ url.appendingPathComponent($0) })
            let files: [Path] = urls.map({ url -> Path in
                let frequencyCount: Int = FF.frequencyCount(for: url)
                return FF.isFolder(url: url) ? Folder(url, at: frequencyCount) : File(url, at: frequencyCount)
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
