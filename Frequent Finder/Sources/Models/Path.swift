//
//  Path.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import Foundation

class Path: ObservableObject, Identifiable, Equatable {
    var id: URL { url }
    var url: URL
    var name: String { url.lastPathComponent }
    var depth: Int { url.path.filter({ $0 == "/" }).count }
    @Published var frequencyCount: Int
    internal init(_ url: URL, at frequencyCount: Int) {
        self.url = url
        self.frequencyCount = frequencyCount
    }
    static func == (lhs: Path, rhs: Path) -> Bool {
        lhs.id == rhs.id
    }
}
