//
//  RootView.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/2/23.
//

import SwiftUI
import GameKit

struct RootView: View {
    
    @StateObject var gameViewModel: GameViewModel
    
    @State private var isShowingGameCenterLogin = false
    @State private var showWelcomeScreen = !UserDefaults.standard.bool(forKey: "DidLaunchBefore")
    @State var showHowTo = false
    @State var showSettings = false
    
    @State var easyGame = false
    @State var mediumGame = false
    @State var hardGame = false
    
    var body: some View {
        
        ZStack {
            BackGroundView()
            
            VStack {
                
                
                //Title
                
                GeometryReader { geo in
                    HStack {
                        Spacer()
                        Text("Blind Sort")
                            .bold()
                            .font(.largeTitle)
                            .frame(width: geo.size.width * 0.8 ,height: geo.size.height * 0.25)
                            .foregroundColor(Color("text-primary"))
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                        .padding(.top, 30)
                        Spacer()
                    }
                }
                
                Spacer()
                
                
                //GameMode select easy(5), medium(10), hard(20)
                ///Create sub-view to eliminate repeat code
                GeometryReader { geo in
                    HStack {
                        Spacer()
                        VStack {
                            ///Easy Game
                            Button {
                                easyGame = true
                            } label: {
                                HStack {
                                    Text("Easy")
                                        .foregroundColor(Color("text-primary"))
                                    Image(systemName: "play.fill")
                                        .foregroundColor(Color("text-primary"))
                                }
                                .font(.title)
                                .padding()
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.30)
                                .background(.ultraThinMaterial)
                                .cornerRadius(14)
                            }
                            ///Medium Game
                            Button {
                                mediumGame = true
                            } label: {
                                HStack {
                                    Text("Medium")
                                        .foregroundColor(Color("text-primary"))
                                    Image(systemName: "play.fill")
                                        .foregroundColor(Color("text-primary"))
                                }
                                .font(.title)
                                .padding()
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.30)
                                .background(.ultraThinMaterial)
                                .cornerRadius(14)
                            }
                            ///Hard Game
                            Button {
                                hardGame = true
                            } label: {
                                HStack {
                                    Text("Hard")
                                        .foregroundColor(Color("text-primary"))
                                    Image(systemName: "play.fill")
                                        .foregroundColor(Color("text-primary"))
                                }
                                .font(.title)
                                .padding()
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.30)
                                .background(.ultraThinMaterial)
                                .cornerRadius(14)
                            }
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                
                
                //How-To and Settings
                HStack {
                    Spacer()
                    Button {
                        showHowTo = true
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)           ///Fix sizing
                            .foregroundStyle(.ultraThinMaterial)
                    }
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)           ///Fix sizing
                            .foregroundStyle(.ultraThinMaterial)
                    }
                }
                .padding(.trailing, 30)
            }
            
        }
        .fullScreenCover(isPresented: $showWelcomeScreen, onDismiss: {
            UserDefaults.standard.set(true, forKey: "DidLaunchBefore")
        }) {
            WelcomeView(showWelcome: $showWelcomeScreen)
        }
        .sheet(isPresented: $showHowTo) {
            InstructionsView(showHowTo: $showHowTo)
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showSettings, content: {
            Settings(isPresented: $showSettings, gameViewModel: GameViewModel(mode: .easy))
                .presentationDragIndicator(.visible)
        })
        .fullScreenCover(isPresented: $easyGame) {
            GameView(gameViewModel: GameViewModel(mode: .easy), isGamePresented: $easyGame)
        }
        .fullScreenCover(isPresented: $mediumGame) {
            GameView(gameViewModel: GameViewModel(mode: .medium), isGamePresented: $mediumGame)
        }
        .fullScreenCover(isPresented: $hardGame) {
            GameView(gameViewModel: GameViewModel(mode: .hard), isGamePresented: $hardGame)
        }
        .onAppear {
            GKAccessPoint.shared.isActive = true
            GKAccessPoint.shared.location = .topTrailing
        }
        .onDisappear {
            GKAccessPoint.shared.isActive = false
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(gameViewModel: GameViewModel(mode: .easy))
    }
}

