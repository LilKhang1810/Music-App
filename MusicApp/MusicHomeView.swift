//
//  MusicHomeView.swift
//  MusicApp
//
//  Created by Nguyễn Khang Hữu on 15/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI
struct MusicHomeView: View {
    @StateObject var controller: MusicController = MusicController()
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false) {
                VStack{
                    ForEach(controller.musics, id: \.self) { music in
                        NavigationLink(destination: MusicPlayView( music: Music(name: music.name, singer: music.singer, url: music.url, img: music.img), audioURL: URL(string: music.url)!).environmentObject(controller)) {
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
                        }
                        Divider()
                    }
                }
            }
            .background(content: {
                Color("accentColor")
                    .ignoresSafeArea()
            })
        }
    }
}

#Preview {
    MusicHomeView()
}
