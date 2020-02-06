//
//  NameView.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-02-01.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import SwiftUI

struct NameView: View {
    @ObservedObject var path: Path
    var font: Font = .system(size: 13)
    var body: some View {
        HStack {
            if path.frequencyCount >= 10 {
                Circle()
                    .foregroundColor(color())
                    .frame(width: 10, height: 10)
            }
            Text(path.name)
                .font(font)
            if path is Folder && (path as! Folder).isGitRoot == true {
                Circle()
                    .frame(width: 10, height: 10)
            }
        }
    }
    func color(satMax: Double = 1.0) -> Color {
        Color(hue: (1 / 12) + (2 / 3) - (2 / 3) * frequencyFraction(upTo: 100), saturation: frequencyFraction(upTo: 10) * satMax, brightness: 1.0, opacity: 1.0)
    }
    func frequencyFraction(upTo: Int) -> Double {
        min(Double(path.frequencyCount) / Double(upTo), 1.0)
    }
}

//struct NameView_Previews: PreviewProvider {
//    static var previews: some View {
//        NameView()
//    }
//}
