//
//  Formatters.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/13/23.
//

import Foundation

struct Formatters {
    static func formatTime(hundredthsOfASecond: Double) -> String {
        let minutes = Int(hundredthsOfASecond) / 6000
        let seconds = (Int(hundredthsOfASecond) % 6000) / 100
        let hundredths = Int(hundredthsOfASecond) % 100
        
        if minutes == 0 {
            return String(format: "%02d.%02d", seconds, hundredths)
        } else {
            return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
        }
    }
    
}
