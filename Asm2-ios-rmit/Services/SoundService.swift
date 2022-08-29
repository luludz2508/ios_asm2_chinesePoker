/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Nguyen Thanh Luan
 ID: s3757937
 Created  date: 14/08/2022
 Last modified: 29/08/2022
 */
import Foundation
import AVFoundation


var bgPlayer: AVAudioPlayer?
var player: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.play()
        } catch {
            print("ERROR: Could not find and play the sound file!")
        }
    }
}

func playBackgroundMusic(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            bgPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            //             backgroundAudioPlayer?.numberOfLoops =  -1
            bgPlayer?.play()
        } catch {
            print("ERROR: Could not find and play the sound file!")
        }
    }
}

func stopBackgroundMusic() {
    bgPlayer?.stop()
}
