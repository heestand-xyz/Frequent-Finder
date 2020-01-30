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
    let components: [String]
    @Published var isGitRoot: Bool?
    init(_ url: URL, at frequencyCount: Int) {
        guard FF.exists(url: url) else { fatalError("url dose not exist") }
        guard FF.isFolder(url: url) else { fatalError("url is not a folder") }
        self.url = url
        self.frequencyCount = frequencyCount
        components = url.path.split(separator: "/").map({ String($0) })
    }
    func fetchContents(done: @escaping () -> ()) {
        guard contents == nil else { done(); return }
        DispatchQueue.global(qos: .background).async {
            let contents = self.getContents()
            DispatchQueue.main.async {
                self.contents = contents
                self.sortContents()
                done()
            }
        }
    }
    func sortContents() {
        contents = contents?.sorted(by: { pathA, pathB -> Bool in
            pathA.frequencyCount > pathB.frequencyCount
        })
    }
    func getContents() -> [Path]? {
        do {
            let rawContent: [String] = try FF.fm.contentsOfDirectory(atPath: url.path)
            let isGit: Bool = rawContent.contains(".git")
            DispatchQueue.main.async {
                self.isGitRoot = isGit
            }
            let filteredContent: [String] = rawContent.filter({ $0.first != "." })
            let urls: [URL] = filteredContent.map({ url.appendingPathComponent($0) })
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
}
