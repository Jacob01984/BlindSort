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
    
    @State var showHowTo = false
    
    var body: some View {
        
        
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            VStack {
                HeaderView(gameViewModel: gameViewModel, isPresented: $isPresented)
                    .padding(.top, 50)
                    .padding(.bottom, 40)
                
                ScrollView {
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
            }
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .frame(width: 90, height: 65)
                                .foregroundColor(Color("text-primary"))
                            
                            VStack {
                                Text("Score:")
                                    .font(.title)
                                Text("\(gameViewModel.score)")
                                    .font(.title2)
                            }
                            .foregroundColor(Color("bubble-primary"))
                        }
                        .padding()
                    }
                }
            }
        }
        
    }
    
    func ListRowPlaced(index: Int, number: Int) -> some View {
        HStack {
            Text("\(index + 1)")
                .foregroundColor(Color("text-primary"))
            ZStack {
                Rectangle()
                    .foregroundColor(Color("icons-input"))
                Text("\(number)")
                    .font(.title)
                    .foregroundColor(Color("text-primary"))
                //.padding(.trailing, 250)
            }
            .frame(width: 350, height: 50)
        }
    }
    
    func ListRow(index: Int) -> some View {
        HStack {
            Text("\(index + 1)")
                .foregroundColor(Color("text-primary"))
            
            ZStack {
                Rectangle()
                    .foregroundColor(.blue)
                Text("-")
                    .foregroundColor(Color("text-secondary"))
                    .font(.title)
            }
            .frame(width: 350, height: 50)
        }
    }
    
    
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameViewModel: GameViewModel(mode: .hard), isPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}
