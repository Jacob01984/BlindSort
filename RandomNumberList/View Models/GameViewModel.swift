//
//  GameViewModel.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/30/23.
//

import Foundation
import AVFAudio

class GameViewModel: ObservableObject {
    @Published private(set) var game: Game
    
    var audioPlayer: AVAudioPlayer?
    
    func playSound(forResource soundName: String, withExtension ext: String = "mp3") {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ext) else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    var numbers: [Int?] {
        game.numbers
    }
    
    var nextNumber: Int {
        game.nextNumber
    }
    
    var score: Int {
        game.score
    }
    
    init(mode: Game.gameMode) {
        game = Game(mode: mode)
        game.generateNextNumber()
    }
    #warning("Find audio for else")
    func placeNumber(at index: Int) {
        if game.placeNumber(at: index) {
                playSound(forResource: "placeNumber")
            } else {
                playSound(forResource: "placeNumber")
            }
            if !game.hasValidMoves() {
                //game.restartGame()
            }
        }
    
    //    func placeNumber(at index: Int) {
    //        if game.placeNumber(at: index) && !game.hasValidMoves() {
    //            //game.restartGame()
    //        }
    //    }
    
    func restartGame() {
        let mode = game.mode
        game = Game(mode: mode)
        game.restartGame()
    }
}
