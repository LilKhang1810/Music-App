//
//  MiniPlayer.swift
//  MusicApp
//
//  Created by Nguyễn Khang Hữu on 18/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI
struct MiniPlayer: View {
    @ObservedObject var controller: MusicController
    @State var isShowingMusicPlayView = false
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                if let music = controller.currentSong {
                    AnimatedImage(url: URL(string: music.img))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55, height: 55)
                    VStack(alignment:.leading){
                        Text(music.name)
                        Text(music.singer)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer(minLength: 0)
                
                Button(action: {
                    Task {
                        if controller.isplaying {
                            await controller.stopAudio()
                        } else {
                            if let music = controller.currentSong {
                                await controller.playAudio(name: music.name)
                            }
                        }
                    }
                }, label: {
                    Image(systemName:  (controller.isplaying == true) ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                })
            }
            .padding(.horizontal)
        }
        .frame(height: 80)
        .background(BlurView())
        .offset(y: -49)
        .onTapGesture {
            isShowingMusicPlayView.toggle()
        }
        .sheet(isPresented: $isShowingMusicPlayView, content: {
            if let music = controller.currentSong {
                MusicPlayView(controller: controller, music: music, currentMusic: music.name)
            }
        })
    }
}
