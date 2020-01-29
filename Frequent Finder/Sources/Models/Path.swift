//
//  Path.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import Foundation

protocol Path {
    var url: URL { get }
    var depth: Int { get }
    var name: String { get }
    var frequencyCount: Int { get }
}
