//
//  ContentView.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/29/23.
//

import SwiftUI
import GameKit

struct GameView: View {
    
    @ObservedObject var gameViewModel: GameViewModel
    
    @Binding var isGamePresented: Bool
    
    @State var showWonGame = false
    
    var body: some View {
        
        ZStack {
            //Background Colors
            LinearGradient(gradient: Gradient(colors: [Color("darkBlue3"), Color("lightBlue"), Color("darkBlue3"), Color("darkBlue2"), Color("darkBlue3"), Color("darkBlue2")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .blur(radius: 80, opaque: true)
            
            GeometryReader { geo in
                HStack {
                    Spacer()
                    VStack {
                        //Header
                        VStack {
                            HeaderView(gameViewModel: gameViewModel, isPresented: $isGamePresented)
                                .frame(width: geo.size.width * 0.94, height: 130)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                        }
                        
                        //List
                        ScrollView {
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
                            .frame(width: geo.size.width * 0.93)
                            .foregroundColor(Color("text-primary"))
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    Spacer()
                }
            }
            
            
            //Score
            VStack {
                GeometryReader { geometry in
                    VStack {
                        Text("Score:")
                            .font(.title)
                        Text("\(gameViewModel.score)")
                            .font(.title2)
                    }
                    .padding(3)
                    .foregroundColor(Color("text-primary"))
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .frame(width: geometry.size.width * 1.70, height: geometry.size.height * 3.3)
                }
                GeometryReader { geometry in
                    VStack {
                        Text("Time:")
                            .font(.title)
                        Text("\(Formatters.formatTime(hundredthsOfASecond: gameViewModel.timeElapsed))")
                            .font(.title2)
                    }
                    .padding(5)
                    .foregroundColor(Color("text-primary"))
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .frame(width: geometry.size.width * 1.70, height: geometry.size.height * 1.7)
                }

            }
        }
        .alert("Game Won!", isPresented: $gameViewModel.wonGame, presenting: gameViewModel) { game in
            Button("Back", role: .cancel) { }
            Button("Next") {
                gameViewModel.restartGame()
            }
        }
        .onAppear {
            GKAccessPoint.shared.isActive = false
        }
        .onDisappear {
            GKAccessPoint.shared.isActive = true
        }
    }
    
    //Populated ListRow
    func ListRowPlaced(index: Int, number: Int) -> some View {
        GeometryReader { geometryy in
            HStack {
                Spacer()
                if index + 1 > 9 {
                    Text("\(index + 1)")
                        .foregroundStyle(.thinMaterial)
                } else {
                    Text("\(index + 1) ")
                        .foregroundStyle(.thinMaterial)
                }
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundStyle(.thinMaterial)
                    Text("\(number)")
                        .font(.title)
                        .foregroundColor(Color("text-primary"))
                }
                .frame(width: geometryy.size.width * 0.85, height: 50, alignment: .leading)
                Spacer()
            }
        }
        .frame(height: 50)
    }
    
    //Empty ListRow
    func ListRow(index: Int) -> some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                if index + 1 > 9 {
                    Text("\(index + 1)")
                        .foregroundColor(Color("text-primary"))
                } else {
                    Text("\(index + 1) ")
                        .foregroundColor(Color("text-primary"))
                }
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundStyle(.ultraThinMaterial)
                        .border(Color("yellow2"), width: gameViewModel.isPlacementValid(at: index) ? 2 : 0)
                        .frame(width: geometry.size.width * 0.85, height: 50)
                    Text("-")
                        .foregroundColor(Color("text-primary"))
                        .font(.title)
                }
                .frame(width: geometry.size.width * 0.85, height: 50, alignment: .leading)
                Spacer()
            }
        }
        .frame(height: 50)
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameViewModel: GameViewModel(mode: .easy), isGamePresented: .constant(true))
    }
}
