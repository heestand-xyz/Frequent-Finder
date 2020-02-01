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
    @ObservedObject var path: Path
    var body: some View {
        ZStack(alignment: .leading) {
            if ff.selectedPath?.url == path.url {
                Color.white.opacity(0.25)
            }
            HStack {
                if path is File {
                    if (path as! File).icon != nil {
                        Image(nsImage: (path as! File).icon!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    NameView(path: path, font: .system(size: 13))
                } else if path is Folder {
                    Button(action: {
                        self.ff.navigate(to: self.path as! Folder)
                    }) {
                        NameView(path: path, font: .system(size: 13))
                    }
//                    .colorMultiply(color(satMax: 0.5))
                }
                Spacer()
                if path.frequencyCount > 0 {
                    Text("\(path.frequencyCount)")
                        .opacity(0.5)
                }
                PathActionView(path: path)
            }
        }
    }
//    func color(satMax: Double = 1.0) -> Color {
//        Color(hue: (1 / 6) + (2 / 3) - (2 / 3) * frequencyFraction(upTo: 100), saturation: frequencyFraction(upTo: 10) * satMax, brightness: 1.0, opacity: 1.0)
//    }
//    func frequencyFraction(upTo: Int) -> Double {
//        min(Double(path.frequencyCount) / Double(upTo), 1.0)
//    }
}

struct PathView_Previews: PreviewProvider {
    static var previews: some View {
        PathView(path: Folder(URL(fileURLWithPath: "/Users/hexagons/Documents"), at: -1))
            .environmentObject(FF.shared)
    }
}
