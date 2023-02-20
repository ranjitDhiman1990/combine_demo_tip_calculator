//
//  AudioPlayService.swift
//  tip-calculator
//
//  Created by Dhiman Ranjit on 19/02/23.
//

import AVFoundation

protocol AudioPlayerService {
    func playSound()
}

final class DefaultAudioPlayer: AudioPlayerService {
    
    private var player: AVAudioPlayer?
    
    func playSound() {
        let path = Bundle.main.path(forResource: "click", ofType: "m4a")!
        let url = URL(filePath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch (let error) {
            print("Audio player error: \(error.localizedDescription)")
        }
    }
}
