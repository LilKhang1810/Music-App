//
//  MiniPlayer.swift
//  MusicApp
//
//  Created by Nguyễn Khang Hữu on 18/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI
struct MiniPlayer: View {
    @Binding var music: Music?
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                if let music = music { // Check if music is not nil
                    AnimatedImage(url: URL(string: music.img))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55, height: 55)
                    Text(music.name)
                } else {
                    // Show an empty mini player or hide it (optional)
                }
                Spacer(minLength: 0)
                Button(action: {
                    // play action
                }, label: {
                    Image(systemName: "play.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                })
            }
            .padding(.horizontal)
        }
        .frame(height: 80)
        .background(BlurView())
        .offset(y: -49)
        .onAppear {
            if let music = music { // Check if music is not nil before printing
                print(music.name)
            }
        }
    }
}
