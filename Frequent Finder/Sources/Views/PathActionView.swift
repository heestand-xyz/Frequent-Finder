//
//  PathActionView.swift
//  Frequent Finder
//
//  Created by Anton Heestand on 2020-01-30.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import SwiftUI

struct PathActionView: View {
    @EnvironmentObject var ff: FF
    let path: Path
    var body: some View {
        HStack {        
            Button(action: {
                self.ff.showInFinder(path: self.path)
            }) {
                Text("Finder")
            }
            if path is File {
                Button(action: {
                    self.ff.open(file: self.path as! File)
                }) {
                    Text("Open")
                }
                Button(action: {
                    self.ff.quickLook(file: self.path as! File)
                }) {
                    Text("Quick Look")
                }
            }
            if path is Folder {
                Button(action: {
                    self.ff.showInTerminal(folder: self.path as! Folder)
                }) {
                    Text("Terminal")
                }
            }
        }
    }
}

struct PathActionView_Previews: PreviewProvider {
    static var previews: some View {
        PathActionView(path: Folder(URL(fileURLWithPath: "/Users/hexagons/Documents"), at: -1))
            .environmentObject(FF.shared)
    }
}
