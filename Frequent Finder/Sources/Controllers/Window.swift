//
//  Window.swift
//  Frequent Finder
//
//  Created by Anton Heestand on 2020-01-30.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import Foundation
import Cocoa

class CommandedWindow: NSWindow {
    
    override func keyDown(with event: NSEvent) {}
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 36: // Enter
            FF.shared.keyEnter()
        case 126: // Up
            FF.shared.keyUp()
        case 125: // Down
            FF.shared.keyDown()
        case 51: // Back
            FF.shared.keyBack()
        default:
            break
        }
    }
    
}
