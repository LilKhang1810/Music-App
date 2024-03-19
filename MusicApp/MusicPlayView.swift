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
    @EnvironmentObject var controller: MusicController
    @Environment(\.dismiss) var dismiss
    @State var music: Music
    @State var currentMusic: String
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    AnimatedImage(url: URL(string: music.img))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350,height: 350)
                        .padding()
                    VStack(alignment:.leading){
                        Text(music.name)
                            .font(.system(size: 25))
                            .bold()
                        Text(music.singer)
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
                                .onTapGesture {
                                    if controller.isplaying{
                                        Task{
                                            await controller.stopAudio()
                                        }
                                    }else{
                                        Task{
                                            await controller.playAudio(name: music.name)
                                        }
                                        
                                    }
                                }
                        })
                        
                        Button(action: {
                            
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
        .navigationBarBackButtonHidden()
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear(perform: {
            Task{
               await fetchAndPlayAudio()
                await controller.playAudio(name: music.name)
            }
            controller.isplaying = true
            
            
        })
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            controller.updateProcess()
        }
    }
    func fetchAndPlayAudio() async {
        do {
            let (data,_) = try await URLSession.shared.data(from: URL(string: music.url)!)
            let audioPlayer = try AVAudioPlayer(data:data)
            controller.player = audioPlayer
            controller.totalTime = audioPlayer.duration
        } catch {
            print("Error fetching or playing audio:", error)
        }
    }
}

#Preview {
    MusicPlayView(music: Music(name: "24K Magic",
                               singer: "Bruno Mars",
                               url: "https://firebasestorage.googleapis.com/v0/b/musicapp-acd69.appspot.com/o/Bruno%20Mars%20-%2024K%20Magic%20(Official%20Music%20Video).mp3?alt=media&token=1254de08-d469-4ac8-93f4-d4b02cddc90a",
                               img :"https://kenh14cdn.com/thumb_w/660/2018/1/31/photo-1-15173842175492010486171.jpg"), currentMusic: "24K Magic"
                  )
    .environmentObject(MusicController())
}
