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
            Color("darkBlue2")
                .ignoresSafeArea()
            
            ScrollView {
                VStack() {
                    Text("Welcome to Blind Number Sort!")
                        //.padding(.trailing, 100)
                    Text("  You are given an empty list, and 20 random numbers one at a time, ranging between 0-1000. The objective is to add each number in ascending order.")
                        .padding(.top, 15)
                    Text("  For example, you are given 56 and you select the position to be at 1, but then the next number is 10, you would lose the game since 10 is less 50 and there is no slot before 1.")
                        .padding(.top, 15)
                    Text("  Once the game detects no valid moves left, it will automatically reset, and you can start over.")
                        .padding(.top, 15)
                    Text("Enjoy the game!")
                        .padding(.top, 15)
                }
                .bold()
                .font(.body)
                .foregroundColor(Color("text-primary"))
                .padding()
            }
        }
    }
}

struct GameInstructions_Previews: PreviewProvider {
    static var previews: some View {
        GameInstructions()
    }
}
