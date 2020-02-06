//
//  FrequentView.swift
//  Frequent Finder
//
//  Created by Anton Heestand on 2020-02-06.
//  Copyright © 2020 Hexagons. All rights reserved.
//

import SwiftUI

struct FrequentView: View {
    @EnvironmentObject var ff: FF
    var body: some View {
        List {
            ForEach(ff.frequentFolders) { folder in
                ItemView(path: folder)
            }
        }
            .frame(width: 200)
    }
}

struct FrequentView_Previews: PreviewProvider {
    static var previews: some View {
        FrequentView()
    }
}
