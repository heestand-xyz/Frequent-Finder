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
        HStack {
            Group {
                if path is Folder {
                    Button(action: {
                        self.ff.navigate(to: self.path as! Folder)
                    }) {
                        Text(path.name)
                    }
                    .foregroundColor(Color(hue: 0.5, saturation: frequencyFraction(), brightness: 1.0, opacity: 1.0))
                } else {
                    Text(path.name)
                }
            }
            Text("\(path.frequencyCount)")
                .opacity(0.5)
            Button(action: {
                self.ff.showInFinder(path: self.path)
            }) {
                Text("Finder")
            }
        }
    }
    func frequencyFraction() -> Double {
        min(Double(path.frequencyCount) / 10, 1.0)
    }
}

struct PathView_Previews: PreviewProvider {
    static var previews: some View {
        PathView(path: Folder(URL(fileURLWithPath: "/Users/hexagons/Documents"), at: -1))
            .environmentObject(FF.shared)
    }
}
