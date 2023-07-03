//
//  Header.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/30/23.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    @State var easyGame = false
    @State var mediumGame = false
    @State var hardGame = false
    
    var body: some View {

        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    
                    Button {
                        easyGame = false
                        mediumGame = false
                        hardGame = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 25)
                            .tint(Color("icons-secondary"))
                    }

                    
                    Spacer()
                    
                    Text("Blind Number Sort")
                        .font(.title3)
                    
                    Spacer()
                    
                    Button {
                        gameViewModel.restartGame()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .frame(width: 30, height: 35)
                            .tint(Color("icons-secondary"))
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color("bubble-primary"))
                            .frame(width: 70, height: 50)
                        Text("\(gameViewModel.nextNumber)")
                            .font(.largeTitle)
                    }
                }
                //.padding(.top, 20)
            }
        }
        .frame(height: 50)
        
        
        
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(gameViewModel: GameViewModel(mode: .easy))
    }
}
