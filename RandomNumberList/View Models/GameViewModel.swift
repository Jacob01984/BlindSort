//
//  GameViewModel.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/30/23.
//

import Foundation
import AVFAudio
import SwiftUI
import GameKit

class GameViewModel: NSObject, GKGameCenterControllerDelegate, ObservableObject, GKLocalPlayerListener {
    
    @Published private(set) var game: Game
    @Published var wonGame: Bool = false
    @AppStorage("isSoundEnabled") var isSoundEnabled: Bool = true
    @Published var gameCenterLoginVC: UIViewController?
    
    
    /*Audio*/
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
    
    
    /*Game Logic*/
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
        super.init()
        self.game.generateNextNumber()
        self.authenticateLocalPlayer()
    }
    
    func isPlacementValid(at index: Int) -> Bool {
        game.isPlacementValid(at: index)
    }
    
    func placeNumber(at index: Int) {
        if game.placeNumber(at: index) {
            playSound(forResource: "placeNumber")
            if game.wonGame(score: game.score) {
                wonGame = true
                
                reportScoreIncrement(context: 0)
            }
            if !game.hasValidMoves() {
                ///Might add
                // game.restartGame()
            }
        } else {
            ///Still need the right audio
            // playSound(forResource: "placeNumber")
        }
    }
    
    func restartGame() {
        let mode = game.mode
        game = Game(mode: mode)
        game.restartGame()
    }
    
    func wonGame(score: Int) -> Bool {
        let hasWon = game.wonGame(score: score)
        
        return hasWon
    }
    
    
    /*Game Center*/
    
    override init() {
        game = Game(mode: .easy)
        super.init()
        game.generateNextNumber()
        authenticateLocalPlayer()
    }
    ///Auth
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                self.gameCenterLoginVC = viewController
            } else if localPlayer.isAuthenticated {
                NSLog("local player is authenticated")
                localPlayer.register(self)
            } else {
                NSLog("player is not authenticated!!!")
            }
        }
    }
    
    ///Access Point
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
    ///Submit Leaderboard Data
    func reportScoreIncrement(context: Int) {
        print("Reporting score increment...") // Debug
        let localPlayer = GKLocalPlayer.local
        let incrementValue = 1
        var leaderboardID: String
        
        switch game.mode {
        case .easy:
            leaderboardID = "grp.AllTimeEasyWon"
        case .medium:
            leaderboardID = "grp.AllTimeMediumWon"
        case .hard:
            leaderboardID = "grp.AllTimeHardWon"
        }
        
        if localPlayer.isAuthenticated {
            print("Local player is authenticated") // Debug
            // Load the current leaderboard
            GKLeaderboard.loadLeaderboards(IDs: [leaderboardID]) { (leaderboards, error) in
                if let error = error {
                    print("Error loading leaderboard: \(error.localizedDescription)")
                    return
                }
                print("Loaded leaderboards") // Debug
                if let leaderboard = leaderboards?.first {
                    leaderboard.loadEntries(for: [localPlayer], timeScope: .allTime) { (localPlayerEntry, entries, error) in
                        if let error = error {
                            print("Error loading entries: \(error.localizedDescription)")
                            return
                        }
                        print("Loaded entries") // Debug
                        // Check the score for the current player
                        if let currentScore = localPlayerEntry {
                            // Increment the score
                            let newScoreValue = currentScore.score + incrementValue
                            print("New score value: \(newScoreValue)") // Debug
                            // Submit the updated score
                            GKLeaderboard.submitScore(newScoreValue, context: context, player: localPlayer, leaderboardIDs: [leaderboardID]) { error in
                                if let error = error {
                                    print("Error submitting score: \(error.localizedDescription)")
                                } else {
                                    print("Score submitted successfully!")
                                }
                            }
                        } else {
                            // Players first win
                            GKLeaderboard.submitScore(incrementValue, context: context, player: localPlayer, leaderboardIDs: [leaderboardID]) { error in
                                if let error = error {
                                    print("Error submitting score: \(error.localizedDescription)")
                                } else {
                                    print("Score submitted successfully!")
                                }
                            }
                        }
                    }
                }
            }
        } else {
            print("Local player is not authenticated") // Debug
        }
    }
}
