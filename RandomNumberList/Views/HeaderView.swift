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
    //Might Keep
                    HStack {
                        ZStack {
                            //RoundedRectangle(cornerRadius: 15)
                                //.foregroundColor(Color("yellow2"))
                                //.frame(width: 95, height: 50)
                            Text("\(gameViewModel.nextNumber)")
                                .font(.largeTitle)
                                .foregroundColor(Color("darkBlue2"))
                                .frame(width: 100, height: 50)
                        }
                        .background(.thinMaterial)
                        .opacity(0.9)
                        .cornerRadius(7)
                    }
                    .shadow(color: .gray, radius: 20, x: 10, y: 5)
                    
                    
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
//                HStack {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 15)
//                            .foregroundColor(Color("yellow2"))
//                            .frame(width: 95, height: 50)
//                        Text("\(gameViewModel.nextNumber)")
//                            .font(.largeTitle)
//                            .foregroundColor(Color("darkBlue2"))
//                    }
//                }
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
