//
//  InstructionsView.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/10/23.
//

import SwiftUI

struct InstructionsView: View {
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("darkBlue3"), Color("darkBlue") , Color("darkBlue3")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack() {
                    Spacer()
                    Text("How-To Play")
                        .font(.title3)
                    Text("  You are given an empty list, and random numbers one at a time, ranging between 0-1000. The objective is to add each number in ascending order.")
                        .padding(.top, 15)
                    Text("For example, you are given 56 and you select the position to be at 1, but then the next number is 10, you would lose the game since 10 is less 50.")
                        .padding(.top, 15)
                    Text("Once the game detects no valid moves left, it will automatically reset, and you can start over.")
                        .padding(.top, 15)
                    Text("Enjoy the game!")
                        .padding(.top, 15)
                    Spacer()
                    
                }
                .bold()
                .font(.body)
                .foregroundColor(Color("text-primary"))
                .padding()
            }
        }
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
