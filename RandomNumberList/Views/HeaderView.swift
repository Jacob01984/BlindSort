//
//  Header.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/30/23.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var gameViewModel: GameViewModel
    
    @Binding var isPresented: Bool
    
    @State var easyGame = false
    @State var mediumGame = false
    @State var hardGame = false
    
    var body: some View {

        ZStack {
            Color("darkBlue2")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    
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
                    
                    Text("Blind Number Sort")
                        .font(.title3)
                        .foregroundColor(Color("icons-secondary"))
                    
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
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("yellow2"))
                            .frame(width: 70, height: 50)
                        Text("\(gameViewModel.nextNumber)")
                            .font(.largeTitle)
                            .foregroundColor(Color("darkBlue2"))
                    }
                }
            }
        }
        .frame(height: 50)   
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(gameViewModel: GameViewModel(mode: .easy), isPresented: .constant(false))
            .preferredColorScheme(.dark)
    }
}
