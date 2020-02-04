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
        print(event.keyCode)
        switch event.keyCode {
        case 36: // Enter
            FF.shared.keyEnter()
        case 126: // Up
            FF.shared.keyUp()
        case 125: // Down
            FF.shared.keyDown()
        case 51: // Back
            FF.shared.keyBack()
        case 49: // Space
            FF.shared.keySpace()
        case 3: // F
            FF.shared.keyF()
        case 17: // T
            FF.shared.keyT()
        default:
            break
        }
    }
    
}
