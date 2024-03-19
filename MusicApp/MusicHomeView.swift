//
//  MusicHomeView.swift
//  MusicApp
//
//  Created by Nguyễn Khang Hữu on 15/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFAudio
struct MusicHomeView: View {
    @EnvironmentObject var controller: MusicController
    @State var isMiniPlayerPresented = false
    @State var selectedMusic: Music? = nil
    var body: some View {
        NavigationStack{
            ZStack{
                ScrollView(showsIndicators: false) {
                    VStack{
                        ForEach(controller.musics, id: \.self) { music in
                            Button(
                                action: {
                                    isMiniPlayerPresented = true
                                    selectedMusic = music
                                    Task{
                                        await fetchAndPlayAudio()
                                    }
                                },
                                label: {
                                    HStack{
                                        AnimatedImage(url: URL(string: music.img))
                                            .resizable()
                                            .frame(width: 60,height: 60)
                                        VStack(alignment:.leading){
                                            Text(music.name)
                                                .font(.system(size:20))
                                                .bold()
                                                .foregroundColor(.black)
                                            Text(music.singer)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Button(action: {
                                            
                                        }, label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.black)
                                        })
                                        
                                    }
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                    .padding()
                                })
                        }
                        
                    }
                    
                }
                
                if selectedMusic != nil {
                    MiniPlayer(music: $selectedMusic)
                        .offset(y:370)
                }
                
            }
        }
    }
    func fetchAndPlayAudio() async {
        do {
            if let selectedMusic = selectedMusic, let url = URL(string: selectedMusic.url) {
                let (data,_) = try await URLSession.shared.data(from: url)
                let audioPlayer = try AVAudioPlayer(data:data)
                controller.player = audioPlayer
                controller.player?.play()
                controller.totalTime = audioPlayer.duration
            } else {
                print("No selected music to play") // Handle case where selectedMusic is nil
            }
        } catch {
            print("Error fetching or playing audio:", error)
        }
    }
}
#Preview {
    MusicHomeView()
        .environmentObject(MusicController())
}
