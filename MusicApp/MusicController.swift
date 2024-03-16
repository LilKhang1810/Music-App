//
//  MusicController.swift
//  MusicApp
//
//  Created by Nguyễn Khang Hữu on 15/03/2024.
//

import Foundation
import Firebase
import AVFoundation
class MusicController: ObservableObject{
    @Published var musics:[Music] = []
    @Published var player: AVAudioPlayer?
    @Published var totalTime: TimeInterval = 0.0
    @Published var currentTime: TimeInterval = 0.0
    @Published var isplaying = false
    private var db = Firestore.firestore()
    init(){
        fetchMusicData()
    }
    func fetchMusicData(){
        let ref = db.collection("Music")
        ref.addSnapshotListener { snapshot, error in
            guard error == nil else{
                return
            }
            if let snapshot = snapshot{
                self.musics = snapshot.documents.compactMap({ document in
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let singer = data["singer"] as? String ?? ""
                    let url = data["url"] as? String ?? ""
                    let img = data["img"] as? String ?? ""
                    return Music(name: name, singer: singer, url: url, img: img)
                })
            }
        }
    }
    
    func playAudio() {
        player?.play()
        isplaying = true
    }
    func stopAudio(){
        player?.stop()
        isplaying = false
    }
    func updateProcess(){
        guard let player = player else{return}
        currentTime = player.currentTime
    }
    func audioTime(to time: TimeInterval){
        player?.currentTime = time
    }
    func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
}