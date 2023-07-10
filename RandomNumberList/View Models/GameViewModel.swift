//
//  GameViewModel.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/30/23.
//

import Foundation
import AVFAudio
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private(set) var game: Game
    @Published var wonGame: Bool = false
    @AppStorage("isSoundEnabled") var isSoundEnabled: Bool = true
    
    var audioPlayer: AVAudioPlayer?
    
    func playSound(forResource soundName: String, withExtension ext: String = "mp3") {
        if isSoundEnabled {
            guard let url = Bundle.main.url(forResource: soundName, withExtension: ext) else { return }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            return
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
    
    func isPlacementValid(at index: Int) -> Bool {
            game.isPlacementValid(at: index)
        }
    
    func placeNumber(at index: Int) {
        if game.placeNumber(at: index) {
            playSound(forResource: "placeNumber")
            wonGame = game.wonGame(score: game.score)
            if !game.hasValidMoves() {
                //game.restartGame()
            }
        } else {
            //playSound(forResource: "placeNumber")       //find audio for !placeNumber
        }
    }
    
    func restartGame() {
        let mode = game.mode
        game = Game(mode: mode)
        game.restartGame()
    }

    func wonGame(score: Int) -> Bool {
        game.wonGame(score: score)
    }
}
