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
    @State var showProfile = false
    
    @State var easyGame = false
    @State var mediumGame = false
    @State var hardGame = false
    
    var body: some View {
        
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("darkBlue3"), Color("darkBlue") , Color("darkBlue3")]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
                .ignoresSafeArea()
            
            VStack {
                //Title
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("yellow1"))
                    
                    Text("Blind Number Sort")
                        .font(.largeTitle)
                        .foregroundColor(Color("text-primary"))
                }
                .frame(width: 350 ,height: 100)
                .padding(.top, 50)
                
                Spacer()
                
                
                //GameCenter LeaderBoard
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .foregroundColor(Color("yellow1"))
//                        .frame(width: 350 ,height: 250)
//                    VStack(alignment: .center) {
//                        HStack {
//                            Spacer()
//                            Text("LeaderBoard")
//                                .padding(.top, 15)
//                                .padding(.leading, 11)
//                            Spacer()
//                            Button {
//                                showProfile = true
//                            } label: {
//                                Image(systemName: "person.circle")
//                                    .font(.title3)
//                            }
//                            .padding(.trailing, 10)
//
//                        }
//                        Spacer()
//                        RoundedRectangle(cornerRadius: 20)          //GameCenter leaderboard goes here
//                            .frame(width: 300 ,height: 150)
//                        Spacer()
//                    }
//                    .frame(width: 350 ,height: 250)
//                }
//
//
//                Spacer()
                
                //GameMode select easy(5), medium(10), hard(20)
                
                //Create sub-view to eliminate repeat code
                Button {
                    easyGame = true
                    GKAccessPoint.shared.isActive = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 350, height: 100)
                            .foregroundColor(Color("yellow1"))
                        HStack {
                            Text("Easy")
                                .foregroundColor(Color("text-primary"))
                            Image(systemName: "play.fill")
                                .foregroundColor(Color("text-primary"))
                        }
                        .font(.title)
                    }
                }
                Button {
                    mediumGame = true
                    GKAccessPoint.shared.isActive = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 350, height: 100)
                            .foregroundColor(Color("yellow1"))
                        HStack {
                            Text("Medium")
                                .foregroundColor(Color("text-primary"))
                            Image(systemName: "play.fill")
                                .foregroundColor(Color("text-primary"))
                        }
                        .font(.title)
                    }
                }
                
                Button {
                    hardGame = true
                    GKAccessPoint.shared.isActive = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 350, height: 100)
                            .foregroundColor(Color("yellow1"))
                        HStack {
                            Text("Hard")
                                .foregroundColor(Color("text-primary"))
                            Image(systemName: "play.fill")
                                .foregroundColor(Color("text-primary"))
                        }
                        .font(.title)
                    }
                    //.opacity(.greatestFiniteMagnitude)
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
                            .frame(width: 30, height: 30)
                            .tint(Color("icons-secondary"))
                    }
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .tint(Color("icons-secondary"))
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
        .fullScreenCover(isPresented: $showProfile, content: {
            UserProfile(showUserProfile: $showProfile)
        })
        .fullScreenCover(isPresented: $easyGame) {
            GameView(gameViewModel: GameViewModel(mode: .easy), isPresented: $easyGame)
        }
        .fullScreenCover(isPresented: $mediumGame) {
            GameView(gameViewModel: GameViewModel(mode: .medium), isPresented: $mediumGame)
        }
        .fullScreenCover(isPresented: $hardGame) {
            GameView(gameViewModel: GameViewModel(mode: .hard), isPresented: $hardGame)
        }
        .onReceive(gameViewModel.$gameCenterLoginVC) { loginVC in
            if loginVC != nil {
                self.isShowingGameCenterLogin = true
            }
        }
    }
}








struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(gameViewModel: GameViewModel(mode: .easy))
            .preferredColorScheme(.dark)
    }
}
