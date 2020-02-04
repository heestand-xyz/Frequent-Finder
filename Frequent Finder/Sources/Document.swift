//
//  Document.swift
//  DocTest
//
//  Created by Anton Heestand on 2019-11-13.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Cocoa
import SwiftUI

class Document: NSDocument, NSWindowDelegate {

    let id: UUID
    
    var main: Main?
    
    override init() {
        id = UUID()
        Swift.print("------------> init", id)
        self.main = Main()
        super.init()
    }
    
    enum DocumentError: Error {
        case mainNotCreated
        case scriptCorrupt
        case badFileType
        case scriptToDataFailed
    }
    
    override class var autosavesInPlace: Bool {
        return false
    }

    override func makeWindowControllers() {
        
        Swift.print("------------> make", main != nil, id)
        
        guard let main = main else { return }
        
        let contentView = ContentView()
            .environmentObject(main)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1000, height: 750),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.delegate = self
        window.contentView = NSHostingView(rootView: contentView)
        let windowController = NSWindowController(window: window)
        self.addWindowController(windowController)
        
    }

    override func data(ofType typeName: String) throws -> Data {
        Swift.print("------------> save", main != nil, id)
        guard let main = main else { Swift.print("doc save failed 1"); throw DocumentError.mainNotCreated }
        let metaData = main.saveMetaData()
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(dateFormatter())
            let metaDataData = try encoder.encode(metaData)
            guard let metaDataJson = String(data: metaDataData, encoding: .utf8) else {
                 Swift.print("doc save failed to convert meta data to string")
                throw DocumentError.scriptToDataFailed
            }
            guard let data = "\(metaDataJson)\n\(main.script)".data(using: .utf8) else {
                Swift.print("doc save failed to merge meta data with script")
                throw DocumentError.scriptToDataFailed
            }
            return data
        } catch {
            Swift.print("doc save failed:", error)
            throw error
        }
    }

    override func read(from data: Data, ofType typeName: String) throws {
        Swift.print("------------> open", main != nil, id)
        guard let main = main else { return }
        do {
            guard let text = String(data: data, encoding: .utf8) else {
                Swift.print("doc open failed to read data")
                throw DocumentError.scriptCorrupt
            }
            let texts = text.split(separator: "\n")
            guard texts.count >= 2 else {
                Swift.print("doc open failed with missing lines")
                throw DocumentError.scriptCorrupt
            }
            guard let metaDataData = String(texts[0]).data(using: .utf8) else {
                Swift.print("doc open failed to convert meta data")
                throw DocumentError.scriptCorrupt
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter())
            let metaData = try decoder.decode(MetaData.self, from: metaDataData)
            main.loadMetaData(metaData)
            main.script = String(texts[1])
        } catch {
            Swift.print("doc open failed:", error)
            throw error
        }
    }

    func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }
    
    func windowDidEndLiveResize(_ notification: Notification) {
        main?.windowDidReize()
    }

}

