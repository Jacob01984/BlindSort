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
    @Published var gameCenterLoginVC: UIViewController?
    
    @AppStorage("isSoundEnabled") var isSoundEnabled: Bool = true
    
    @Published var timeElapsed: Double = 0.0
    var timer: Timer? = nil
    var isFirstCall = true
    
    //
    //
    //Audio
    //
    //
    
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
    
    //
    //
    //Game Logic
    //
    //
    
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
        if isFirstCall {
            startTimer()
            isFirstCall = false
        }
        if game.placeNumber(at: index) {
            playSound(forResource: "placeNumber")
            if game.wonGame(score: game.score) {
                wonGame = true
                print("Time: \(timeElapsed)")
                reportScoreIncrement(context: 0)
                reportElapsedTime(context: 1, timeElapsed: timeElapsed)
            }
            if !game.hasValidMoves() {
                ///Might add
                /// game.restartGame()
                stopTimer()
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
        self.timeElapsed = 0.0
        stopTimer()
        isFirstCall = true
    }
    
    func wonGame(score: Int) -> Bool {
        let hasWon = game.wonGame(score: score)
        
        return hasWon
    }
    ///Timer
    func startTimer() {
        self.timer?.invalidate()
        self.timeElapsed = 0.0
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        self.timeElapsed += 1.0
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    //
    //
    //Game Center
    //
    //
    
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
    
    ///Submit/ Update All-Time Win Leaderboard Score
    func reportScoreIncrement(context: Int) {
        print("Reporting score increment...") // Debug
        let localPlayer = GKLocalPlayer.local
        let incrementValue = 1
        var leaderboardID: String
        let achievementID: String
        
        switch game.mode {
        case .easy:
            leaderboardID = "grp.AllTimeEasyWon"
            achievementID = "grp.beatEazyGame"
        case .medium:
            leaderboardID = "grp.AllTimeMediumWon"
            achievementID = "grp.beatMediumGame"
        case .hard:
            leaderboardID = "grp.AllTimeHardWon"
            achievementID = "grp.beatHardGame"
        }
        
        if localPlayer.isAuthenticated {
            print("Local player is authenticated(AllTime)") // Debug
            // Load the current leaderboard
            GKLeaderboard.loadLeaderboards(IDs: [leaderboardID]) { (leaderboards, error) in
                if let error = error {
                    print("Error loading leaderboard(AllTime): \(error.localizedDescription)")
                    return
                }
                print("Loaded leaderboards(AllTime)") // Debug
                if let leaderboard = leaderboards?.first {
                    leaderboard.loadEntries(for: [localPlayer], timeScope: .allTime) { (localPlayerEntry, entries, error) in
                        if let error = error {
                            print("Error loading entries(AllTime): \(error.localizedDescription)")
                            return
                        }
                        print("Loaded entries(AllTime)") // Debug
                        // Check the score for the current player
                        if let currentScore = localPlayerEntry {
                            // Increment the score
                            let newScoreValue = currentScore.score + incrementValue
                            print("New score value(AllTime): \(newScoreValue)") // Debug
                            // Submit the updated score
                            GKLeaderboard.submitScore(newScoreValue, context: context, player: localPlayer, leaderboardIDs: [leaderboardID]) { error in
                                if let error = error {
                                    print("Error submitting score(AllTime): \(error.localizedDescription)")
                                } else {
                                    print("Score submitted successfully!(AllTime)")
                                }
                            }
                        } else {
                            // Players first win
                            GKLeaderboard.submitScore(incrementValue, context: context, player: localPlayer, leaderboardIDs: [leaderboardID]) { error in
                                if let error = error {
                                    print("Error submitting score(AllTime): \(error.localizedDescription)")
                                } else {
                                    print("Score submitted successfully!(AllTime)")
                                    //Reward achievement on first game won
                                    if incrementValue == 1 {
                                        GameCenterHelper.getAchievements(achievementId: achievementID, percent: 100)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            print("Local player is not authenticated(AllTime)") // Debug
        }
    }
    
    ///Submit/ Update All-Time Win Leaderboard Score
    func reportElapsedTime(context: Int, timeElapsed: Double) {
        let localPlayer = GKLocalPlayer.local
        let timeLeaderboardsID: String
        
        switch game.mode {
        case .easy:
            timeLeaderboardsID = "grp.FastestEasyGameWon"
        case .medium:
            timeLeaderboardsID = "grp.FastestMediumGameWon"
        case .hard:
            timeLeaderboardsID = "grp.FastestHardGameWon"
        }
        
        if localPlayer.isAuthenticated {
            print("Local player is authenticated(fastest)") // Debug
            // Load the current leaderboard
            GKLeaderboard.loadLeaderboards(IDs: [timeLeaderboardsID]) { (leaderboards, error) in
                if let error = error {
                    print("Error loading leaderboard(fastest): \(error.localizedDescription)")
                    return
                }
                print("Loaded leaderboards(fastest)") // Debug
                if let leaderboard = leaderboards?.first {
                    leaderboard.loadEntries(for: [localPlayer], timeScope: .allTime) { (localPlayerEntry, entries, error) in
                        if let error = error {
                            print("Error loading entries(fastest): \(error.localizedDescription)")
                            return
                        }
                        print("Loaded entries(fastest)") // Debug
                        // Check the score for the current player
                        if let currentScore = localPlayerEntry {
                            // Only submit score if its less than the previous score
                            if Int(timeElapsed) < currentScore.score {
                                print("New score value(fastest): \(timeElapsed)") // Debug
                                // Submit the updated score
                                GKLeaderboard.submitScore(Int(timeElapsed), context: context, player: localPlayer, leaderboardIDs: [timeLeaderboardsID]) { error in
                                    if let error = error {
                                        print("Error submitting score(fastest): \(error.localizedDescription)")
                                    } else {
                                        print("Score submitted successfully(fastest)!")
                                    }
                                }
                            }
                        } else {
                            // Players first win post time
                            GKLeaderboard.submitScore(Int(timeElapsed), context: context, player: localPlayer, leaderboardIDs: [timeLeaderboardsID]) { error in
                                if let error = error {
                                    print("Error submitting score(fastest): \(error.localizedDescription)")
                                } else {
                                    print("Score submitted successfully(fastest)!")
                                }
                            }
                        }
                    }
                }
            }
        } else {
            print("Local player is not authenticated(fastest)") // Debug
        }
        
    }
}
