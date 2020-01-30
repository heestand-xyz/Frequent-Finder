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
                Section(header: ZStack {
                    if folder.isGitRoot == true {
                        Color.orange.opacity(0.5)
                    }
                    HStack {
                        Button(action: {
                            self.ff.goUp()
                        }) {
                            Text("Up")
                        }
                        .disabled(!ff.canGoUp)
                        Text(folder.name)
                            .font(.headline)
                        PathActionView(path: folder as Path)
                        Spacer()
                    }
                }) {
                    Group {
                        if folder.contents != nil {
                            ForEach(folder.contents!, id: \.url) { path in
                                PathView(path: path)
                                    .padding(.top, self.over(limits: [1, 10, 100, 1000], for: path) ? 15 : 0)
                            }
                        } else {
                            Text("Loading...")
                        }
                    }
                }
            }
            HStack {
                Group {
                    ForEach(folder.components, id: \.self) { component in
                        Button(action: {
                            let allSections: [String] = self.folder.components.map({ String($0) })
                            var targetSections: [String] = []
                            guard let index: Int = self.folder.components.firstIndex(of: component) else { return }
                            for (i, section) in allSections.enumerated() {
                                guard i <= index else { break }
                                targetSections.append(section)
                            }
                            let url: URL = URL(fileURLWithPath: "/" + targetSections.joined(separator: "/"))
                            let frequencyCount: Int = FF.frequencyCount(for: url)
                            let folder: Folder = Folder(url, at: frequencyCount)
                            self.ff.navigate(to: folder)
                        }) {
                            Text(component)
                        }
                            .disabled(component == self.folder.components.last)
                    }
                }
                    .offset(x: 5, y: -5)
                Spacer()
            }
        }
        .onAppear {
            self.folder.fetchContents(done: {})
        }
    }
    func over(limits: [Int], for path: Path) -> Bool {
        for limit in limits {
            if over(limit: limit, for: path) {
                return true
            }
        }
        return false
    }
    func over(limit: Int, for path: Path) -> Bool {
        guard path.frequencyCount < limit else { return false }
        guard let contents: [Path] = self.folder.contents else { return false }
        guard let index: Int = contents.firstIndex(where: { $0.url == path.url }) else { return false }
        let prevIndex: Int = index - 1
        guard prevIndex >= 0 else { return false }
        let prevPath: Path = contents[prevIndex]
        guard prevPath.frequencyCount >= limit else { return false }
        return true
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(folder: Folder(URL(fileURLWithPath: "/Users/hexagons/Documents"), at: -1))
            .environmentObject(FF.shared)
    }
}
