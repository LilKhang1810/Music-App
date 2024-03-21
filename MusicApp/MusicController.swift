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
    @Published var currentSongURL: URL?
    @Published var currentSong: Music?
    @Published var currentMusicIndex:Int = 0
    private var db = Firestore.firestore()
    func fetchMusicData(){
        
        let musicDB = db.collection("Music")
        musicDB.addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
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
    
    func fetchAndPlayAudio(url: String) async {
        do {
            let (data,_) = try await URLSession.shared.data(from: URL(string: url)!)
            let audioPlayer = try AVAudioPlayer(data:data)
            player = audioPlayer
            player?.play()
            totalTime = audioPlayer.duration
            isplaying = true
        } catch {
            print("Error fetching or playing audio:", error)
        }
    }
    func playAudio(name: String) async {
        player?.play()
        isplaying = true
    }
    func stopAudio()async{
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
    func playNextSong() -> Music? {
        guard currentMusicIndex < musics.count - 1 else {
            print("End of playlist reached")
            return nil
        }
        
        currentMusicIndex += 1
        currentSong = musics[currentMusicIndex]
        
        // Cập nhật URL của bài hát mới
        guard let newMusic = currentSong else {
            return nil
        }
        print("Playing next song: \(newMusic.name) by \(newMusic.singer)")
        return newMusic
    }
}
