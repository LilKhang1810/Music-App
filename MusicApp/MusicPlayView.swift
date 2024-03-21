//
//  MusicPlayView.swift
//  MusicApp
//
//  Created by Nguyễn Khang Hữu on 15/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation
struct MusicPlayView: View {
    @ObservedObject var controller : MusicController
    @Environment(\.dismiss) var dismiss
    @State var music: Music
    @State var currentMusic: String
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.compact.down")
                            .padding(.top)
                            .foregroundColor(.black)
                    }
                    AnimatedImage(url: URL(string: controller.currentSong?.img ?? ""))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350,height: 350)
                        .padding()
                    VStack(alignment:.leading){
                        Text(controller.currentSong?.name ?? "")
                            .font(.system(size: 25))
                            .bold()
                        Text(controller.currentSong?.singer ?? "")
                            .font(.system(size: 18))
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding()
                    VStack{
                        Slider(
                            value:
                                Binding(
                                    get:{controller.currentTime},
                                    set: { newValue in
                                        controller.audioTime(to: newValue)
                                    }
                                ),in: 0...controller.totalTime
                        )
                        .padding([.top, .trailing, .leading], 20)
                        HStack{
                            Text(controller.timeString(time: controller.currentTime))
                            Spacer()
                            Text(controller.timeString(time: controller.totalTime))
                        }
                        .font(.caption)
                        .foregroundColor(.black).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal,10)
                    }
                    HStack(spacing:20){
                        Button {
                            
                        } label: {
                            Image(systemName: "shuffle")
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "backward.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .padding(20)
                            
                        })
                        
                        Button(action: {
                            if controller.isplaying {
                                Task {
                                    await controller.stopAudio()
                                }
                            } else {
                                Task {
                                    await controller.playAudio(name: music.name)
                                }
                                controller.isplaying.toggle() // Update isPlaying state
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Delay UI update by 0.1 seconds
                                // Update button image based on isPlaying
                            }
                        }, label: {
                            Image(systemName:  controller.isplaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                                .padding(25)
                                .background{
                                    ZStack{
                                        Color("accentColor")
                                        Circle()
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: -8, y: -8)
                                        Circle()
                                            .fill(.yellow)
                                            .padding(2)
                                            .blur(radius: 2)
                                    }
                                }
                                .clipShape(Circle())
                                .shadow(color: .yellow.opacity(0.5), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 5, y: 3)
                            
                        })
                        
                        Button(action: {
                            controller.playNextSong()
                        }, label: {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .padding(20)
                            
                        })
                        Button {
                            
                        } label: {
                            Image(systemName: "repeat")
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(content: {
                Color("accentColor")
                    .ignoresSafeArea()
            })
        }
        .onAppear{
            controller.updateProcess()
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            controller.updateProcess()
        }
    }
    
}

#Preview {
    MusicPlayView(controller: MusicController(),
                  music: Music(name: "24K Magic",
                               singer: "Bruno Mars",
                               url: "https://firebasestorage.googleapis.com/v0/b/musicapp-acd69.appspot.com/o/24K%20Magic.mp3?alt=media&token=54716ac4-dfc3-4c49-b031-d9b81da36b59",
                               img :"https://kenh14cdn.com/thumb_w/660/2018/1/31/photo-1-15173842175492010486171.jpg"),currentMusic: "24K Magic"
    )
}
