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
    var size :CGSize
    var safeArea: EdgeInsets
    var body: some View {
        
        
        ScrollView(.vertical,showsIndicators: false) {
            VStack{
                ImageSection()
                    .ignoresSafeArea()
                AlbumView()
                    .padding(.bottom,80)
            }
            .overlay(alignment:.top){
                HeaderView()
            }
        }
        .coordinateSpace(name: "SCROLL")
        .onAppear{
            print(controller.isplaying)
            controller.fetchMusicData()
        }
        .overlay {
            if controller.currentSong != nil {
                MiniPlayer(controller: controller)
                    .environmentObject(controller)
                    .offset(y:420)
            }
        }
    }
    
    @ViewBuilder
    func ImageSection() -> some View{
        let height = size.height * 0.45
        GeometryReader{proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / (height*0.8)
            Image("chill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width,height: size.height + (minY > 0 ? minY:0))
                .clipped()
                .overlay{
                    ZStack(alignment:.bottom){
                        Rectangle()
                            .fill(
                                .linearGradient(colors:[
                                    .white.opacity(0-progress),
                                    .white.opacity(0.1-progress),
                                    .white.opacity(0.3-progress),
                                    .white.opacity(0.5-progress),
                                    .white.opacity(0.8-progress),
                                    .white.opacity(1)
                                ], startPoint: .top, endPoint: .bottom)
                            )
                        VStack(spacing:0){
                            Text("My Playlist")
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                        .opacity(1+(progress>0 ? -progress : progress))
                        .padding(.bottom,55)
                        .offset(y:minY)
                    }
                }
                .offset(y:-minY)
        }
        .frame(height: height+safeArea.top)
    }
    @ViewBuilder
    func AlbumView() -> some View{
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
    }
    @ViewBuilder
    func HeaderView() -> some View{
        GeometryReader{proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height*(minY > 0 ? 0.5: 0.0))
            let titleProgress = minY/height
            HStack(spacing: 15){
                Button{
                    
                }label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                Spacer(minLength: 0)
                Button{
                    
                }label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(.black)
                }
            }
            .overlay{
                Text("My Playlist")
                    .fontWeight(.semibold)
                    .offset(y:-titleProgress > 0.75 ? 0 : 45)
                    .clipped()
                    .animation(.easeInOut(duration: 0.25), value: -titleProgress>0.75)
            }
            .padding(.top,safeArea.top+10)
            .padding([.horizontal,.bottom],15)
            .background(content: {
                Color("accentColor").opacity(-progress)
            })
            .offset(y:-minY)
        }
        .frame(height: 35)
    }
}
#Preview {
    ContentView()
        .environmentObject(MusicController() )
}
