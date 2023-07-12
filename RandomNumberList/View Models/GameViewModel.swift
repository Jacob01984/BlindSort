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
    
    //Audio
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
    
    //Game Logic
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
        GKAccessPoint.shared.isActive = true
        GKAccessPoint.shared.location = .bottomLeading
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
        let hasWon = game.wonGame(score: score)
        if hasWon {
            let leaderboardID = "grp.AllTimeEasyWon" // replace with your leaderboard ID
            let context = 0 // replace with the context you want to use

            reportScore(score: score, context: context, forLeaderboardID: leaderboardID)
            reportScoreIncrement(context: context, forLeaderboardID: leaderboardID)
        }
        return hasWon
    }
    
    //Game Center
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
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    ///Submit Leaderboard Data
    func reportScore(score: Int, context: Int, forLeaderboardID leaderboardID: String) {
            let localPlayer = GKLocalPlayer.local

            if localPlayer.isAuthenticated {
                //let leaderboardScore = GKLeaderboardScore(leaderboardIdentifier: leaderboardID, player: localPlayer, value: score)
                GKLeaderboard.submitScore(score, context: context, player: localPlayer, leaderboardIDs: ["grp.AllTimeEasyWon"]) { error in
                    if let error = error {
                        print("Error submitting score: \(error.localizedDescription)")
                    } else {
                        print("Score submitted successfully!")
                    }
                }
            }
        }
    
    func reportScoreIncrement(context: Int, forLeaderboardID leaderboardID: String) {
        let localPlayer = GKLocalPlayer.local
        let incrementValue = 1 // increment by 1 for each win

        if localPlayer.isAuthenticated {
            // Load the current leaderboard
            GKLeaderboard.loadLeaderboards(IDs: [leaderboardID]) { (leaderboards, error) in
                if let error = error {
                    print("Error loading leaderboard: \(error.localizedDescription)")
                    return
                }

                if let leaderboard = leaderboards?.first {
                    leaderboard.loadEntries(for: [localPlayer], timeScope: .allTime) { (localPlayerEntry, entries, error) in
                        if let error = error {
                            print("Error loading entries: \(error.localizedDescription)")
                            return
                        }

                        // Check the score for the current player
                        if let currentScore = localPlayerEntry {
                            // Increment the score
                            let newScoreValue = currentScore.score + incrementValue

                            // Submit the updated score
                            GKLeaderboard.submitScore(newScoreValue, context: context, player: localPlayer, leaderboardIDs: [leaderboardID]) { error in
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
        }
    }
}
