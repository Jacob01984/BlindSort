//
//  GameInstructions.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/30/23.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var showWelcome: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("darkBlue3"), Color("darkBlue") , Color("darkBlue3")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack() {
                    Spacer()
                    Text("Welcome to Blind Number Sort!")
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 9)
                            .foregroundColor(Color("yellow1"))
                            .frame(width: 250, height: 50)
                        Button {
                            showWelcome = false
                        } label: {
                            Image(systemName: "play.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color("text-primary"))
                        }
                    }
                    .padding(.top, 200)
                    
                }
                .bold()
                .font(.body)
                .foregroundColor(Color("text-primary"))
                .padding()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(showWelcome: .constant(true))
    }
}
