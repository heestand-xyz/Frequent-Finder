//
//  Shell.swift
//  Frequent Finder
//
//  Created by Anton Heestand on 2020-01-30.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import Foundation

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}
