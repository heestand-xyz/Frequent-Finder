//
//  ContentView.swift
//  Frequent Finder
//
//  Created by Hexagons on 2020-01-29.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var ff: FF
    var body: some View {
        FolderView(folder: ff.currentFolder)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                self.ff.didAppear()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FF.shared)
    }
}
