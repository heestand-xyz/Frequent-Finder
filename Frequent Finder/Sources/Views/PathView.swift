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
            } else {
                Color.white.opacity(0.025)
            }
            HStack {
                ItemView(path: path)
                Spacer()
                if path.frequencyCount > 0 {
                    Text("\(path.frequencyCount)")
                        .opacity(0.5)
                }
                PathActionView(path: path)
            }
        }
        .onTapGesture {
            if self.ff.selectedPath == self.path {
                self.ff.enter(path: self.path)
            } else {
                self.ff.selectedPath = self.path
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
