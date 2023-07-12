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
        game.wonGame(score: score)
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
    
    ///Game Center Access Point
//    func configureAccessPoint() {
//            let accessPoint = GKAccessPoint.shared
//
//            // Set the location of the Access Point
//            accessPoint.location = .topLeading
//
//            // Show highlights like achievements
//            accessPoint.showHighlights = true
//
//            // Activate the Access Point
//            accessPoint.isActive = true
//        
//        }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
    class func submitScore(score: Int, player: GKLocalPlayer, LeaderboardsIDS: [String]) {
        
        
    }
    
}
