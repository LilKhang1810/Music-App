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
    @EnvironmentObject var controller: MusicController
    @State var isShowingMusicPlayView = false
    var body: some View {
        NavigationStack{
            VStack {
                HStack(spacing: 15) {
                    if let music = music { // Check if music is not nil
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
                    } else {
                        // Show an empty mini player or hide it (optional)
                    }
                    Spacer(minLength: 0)
                    Button(action: {
                        Task {
                            if controller.isplaying {
                                await controller.stopAudio()
                            } else {
                                if let music = music {
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
            .onAppear {
                if let music = music { // Kiểm tra xem music có nil hay không
                    Task {
                        await controller.fetchAndPlayAudio(url: music.url)
                    }
                }
            }
            .onTapGesture {
                isShowingMusicPlayView.toggle()
            }
        }
        .sheet(isPresented: $isShowingMusicPlayView, content: {
            MusicPlayView(controller: controller, music: music!, currentMusic: music!.name)
        })
    }
}
