//
//  GameInstructions.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/30/23.
//

import SwiftUI

struct GameInstructions: View {
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            ScrollView {
                        Text("""
                            Welcome to the Game!

                            You are given an empty list of 1-20, and you are given 20 random numbers, one at a time, ranging between 0-1000.

                            The objective is to add each number in ascending order. For example, you are given 56 and you select the position to be at 1, but then the next number is 10, you would lose the game since 10 is less 50 and there is no slot before 1.

                            Once the game detects no valid moves left, it will automatically reset, and you can start over.

                            Enjoy the game!
                            """)
                            .padding()
                            .font(.body)
            }
        }
    }
}

struct GameInstructions_Previews: PreviewProvider {
    static var previews: some View {
        GameInstructions()
    }
}
