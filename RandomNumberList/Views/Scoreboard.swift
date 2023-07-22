//
//  Scoreboard.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/15/23.
//

import SwiftUI

struct Scoreboard: View {
    @State var score = 2
    @State private var time = 493.3
    
    var body: some View {
        
        //GeometryReader { geometry in
        ZStack {
            Color("darkBlue3")
                .ignoresSafeArea()
                
            VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Text("Score:")
                                .font(.title)
                            Text("\(score)")
                                .font(.title2)
                        }
                        .frame(width: 125, height: 75)
                        .padding(.horizontal)
                        .foregroundColor(Color("text-primary"))
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        
                        VStack {
                            Text("Time:")
                                .font(.title)
                            Text("\(Formatters.formatTime(hundredthsOfASecond: time))")
                                .font(.title2)
                        }
                        .frame(width: 125, height: 75)
                        .padding(.horizontal)
                        .foregroundColor(Color("text-primary"))
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        Spacer()
                    }
                    .frame(width: 50, height: 150)
                    Spacer()
            }
        }
       // }
        
        
    }
}

struct Scoreboard_Previews: PreviewProvider {
    static var previews: some View {
        Scoreboard()
    }
}
