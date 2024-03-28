//
//  ContentView.swift
//  MusicApp
//
//  Created by Nguyễn Khang Hữu on 15/03/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var controller: MusicController
    var body: some View {
        GeometryReader{
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            MusicHomeView(size: size, safeArea: safeArea)
                .environmentObject(controller)
                .ignoresSafeArea(.container,edges: .top)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
   ContentView()
        .environmentObject(MusicController())
}
