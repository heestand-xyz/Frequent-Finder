//
//  FolderView.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import SwiftUI

struct FolderView: View {
    @EnvironmentObject var ff: FF
    @ObservedObject var folder: Folder
    var body: some View {
        VStack {
            List {
                Section(header: Group {
                    HStack {
                        Button(action: {
                            self.ff.goUp()
                        }) {
                            Text("Back")
                        }
                        .disabled(!ff.canGoUp)
                        Text(folder.name)
                            .font(.headline)
                    }
                }) {
                    ForEach(folder.contents ?? [], id: \.url) { path in
                        PathView(path: path)
                    }
                }
            }
            HStack {
                Text(folder.url.path)
                    .offset(x: 5, y: -5)
                Spacer()
            }
        }
        .onAppear {
            self.folder.fetchContents()
        }
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(folder: Folder(URL(fileURLWithPath: "/Users/hexagons/Documents")))
    }
}
