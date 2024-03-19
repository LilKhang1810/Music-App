//
//  ContentView.swift
//  MusicApp
//
//  Created by Nguyễn Khang Hữu on 15/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab = 0
    @EnvironmentObject var controller: MusicController
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView {
                MusicHomeView()
                    .tag(0)
                    .tabItem {
                        Image(systemName: "house")
                            .tag(0)
                    }
                Text("Search View")
                    .tag(0)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                            .tag(1)
                    }
                Text("Profile View")
                    .tag(0)
                    .tabItem {
                        Image(systemName: "person")
                            .tag(0)
                    }
            }
            
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MusicController())
}
