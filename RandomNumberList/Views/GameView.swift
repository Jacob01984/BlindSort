//
//  ContentView.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/29/23.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var gameViewModel: GameViewModel
    
    @Binding var isPresented: Bool
    
    @State var showWonGame = false
    
    
    var body: some View {
        
        
        ZStack {
            Color("darkBlue2")
                .ignoresSafeArea()
            
            VStack {

                    HeaderView(gameViewModel: gameViewModel, isPresented: $isPresented)
                        .padding(.top, 50)
                        .padding(.bottom, 40)
            
                
                //List
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: RoundedCornerStyle.continuous)
                            .frame(width: 415)
                            .foregroundColor(Color("darkBlue3"))
                            .ignoresSafeArea()
                        VStack {
                            ForEach(gameViewModel.numbers.indices, id: \.self) { index in
                                Button(action: {
                                    gameViewModel.placeNumber(at: index)
                                }) {
                                    if let number = gameViewModel.numbers[index] {
                                        ListRowPlaced(index: index, number: number)
                                    } else {
                                        ListRow(index: index)
                                    }
                                }
                                .disabled(gameViewModel.numbers[index] != nil)
                            }
                        }
                        .padding(.bottom, 25)
                        .padding(.top)
                    }
                }
                .padding(.top, 20)
                
                
            }
            
            //Score
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 90, height: 65)
                                .foregroundColor(Color("darkBlue2"))
                            
                            VStack {
                                Text("Score:")
                                    .font(.title)
                                Text("\(gameViewModel.score)")
                                    .font(.title2)
                            }
                            .foregroundColor(Color("text-primary"))
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        
        .alert("Game Won!", isPresented: $gameViewModel.wonGame, presenting: gameViewModel) { game in
            Button("Back", role: .cancel) { }
            Button("Next") {
                gameViewModel.restartGame()
            }
        }
    }
    
    func ListRowPlaced(index: Int, number: Int) -> some View {
        
        HStack {
            Spacer()
            Text("\(index + 1)")
                .foregroundColor(Color("text-primary"))
            Spacer()
            ZStack {
                Rectangle()
                    .foregroundColor(Color("darkBlue3"))
                Text("\(number)")
                    .font(.title)
                    .foregroundColor(Color("text-primary"))
                //.padding(.trailing, 250)
            }
            .frame(width: 350, height: 50)
            Spacer()
        }
    }
    
    func ListRow(index: Int) -> some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                Text("\(index + 1)")
                    .foregroundColor(Color("text-primary"))
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("darkBlue3"))
                        .border(Color("yellow2"), width: gameViewModel.isPlacementValid(at: index) ? 2 : 0)
                    
                    Text("-")
                        .foregroundColor(Color("text-primary"))
                        .font(.title)
                }
                .frame(width: geometry.size.width * 0.85, height: 50)
                Spacer()
            }
        }
        .frame(height: 50)
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameViewModel: GameViewModel(mode: .medium), isPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}
