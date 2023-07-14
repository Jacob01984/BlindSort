//
//  Header.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/30/23.
//

import SwiftUI
import GameKit

struct HeaderView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    @Binding var isPresented: Bool
    
    @State var showActionSheet = false
    
    @State var easyGame = false
    @State var mediumGame = false
    @State var hardGame = false
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                HStack {
                    //Back to Root View
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 25)
                            .tint(Color("icons-secondary"))
                    }
                    
                    Spacer()
                    
                    Text("Blind Sort")
                        .font(.title3)
                        .foregroundColor(Color("text-primary"))
                    
                    Spacer()
                    //Restart Game
                    Button {
                        if gameViewModel.isFirstCall || gameViewModel.noValidMoves() {
                            gameViewModel.restartGame()
                        } else {
                            showActionSheet = true
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .frame(width: 30, height: 35)
                            .tint(Color("icons-secondary"))
                    }
                    
                }
                .padding(.horizontal)
                
                //Game generated number
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("yellow2"))
                            .frame(width: 95, height: 50)
                        Text("\(gameViewModel.nextNumber)")
                            .font(.largeTitle)
                            .foregroundColor(Color("darkBlue2"))
                    }
                }
            }
            .padding(.top, geo.size.height * 0.15)
            .padding(.bottom, geo.size.height * 0.15)
            .foregroundColor(Color("text-primary"))
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            
        }
        
        .confirmationDialog("Confirm", isPresented: $showActionSheet) {
            Button("Restart Game", role: .destructive) {
                gameViewModel.restartGame()
            }
            Button("Cancel", role: .cancel) {
            }
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(gameViewModel: GameViewModel(mode: .easy), isPresented: .constant(false))
    }
}
