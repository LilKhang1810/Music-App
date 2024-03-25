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
    
    var body: some View {
        NavigationStack{
            ZStack{
                ScrollView(showsIndicators: false) {
                    VStack{
                        ForEach(controller.musics, id: \.self) { music in
                            Button(
                                action: {
                                    isMiniPlayerPresented = true
                                    controller.currentSong = music
                                    Task{
                                        await controller.fetchAndPlayAudio(url: music.url)
                                    
                                    }
                                    controller.isplaying = true
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
                    .padding(.bottom,80)
                }
                
                if controller.currentSong != nil {
                    MiniPlayer(controller: controller)
                        .environmentObject(controller)
                        .offset(y:370)
                }
                
            }
        }
        .onAppear{
            print(controller.isplaying)
            controller.fetchMusicData()
            
        }
    }

}
#Preview {
    MusicHomeView()
        .environmentObject(MusicController())
}
