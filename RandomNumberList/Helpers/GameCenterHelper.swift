//
//  GameCenterHelper.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/13/23.
//

import Foundation
import GameKit

struct GameCenterHelper {
    ///Achievenments
    static func getAchievements( achievementId: String, percent: Double) {
        var achievements = [GKAchievement]()
        
        let reportAchievement = GKAchievement(identifier: achievementId)
        reportAchievement.percentComplete = percent
        achievements.append(reportAchievement)
        
        GKAchievement.report(achievements) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Achievement Successful")
            }
        }
    }
}
