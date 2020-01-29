//
//  PathView.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import SwiftUI

struct PathView: View {
    @EnvironmentObject var ff: FF
    let path: Path
    var body: some View {
        Group {
            if path is Folder {
                Button(action: {
                    self.ff.currentFolder = self.path as! Folder
                }) {
                    Text(path.name)
                }
            } else {
                Text(path.name)
            }
        }
    }
}

struct PathView_Previews: PreviewProvider {
    static var previews: some View {
        PathView(path: Folder(URL(fileURLWithPath: "/Users/hexagons/Documents")))
    }
}
