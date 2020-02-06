//
//  ItemView.swift
//  Frequent Finder
//
//  Created by Anton Heestand on 2020-02-06.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var ff: FF
    @ObservedObject var path: Path
    var body: some View {
        HStack {
            if path is File {
                if (path as! File).icon != nil {
                    Image(nsImage: (path as! File).icon!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                NameView(path: path)
            } else if path is Folder {
                Button(action: {
                    self.ff.navigate(to: self.path as! Folder)
                }) {
                    NameView(path: path)
                }
            }
        }
    }
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
