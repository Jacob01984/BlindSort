//
//  Settings.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/3/23.
//

import SwiftUI
import GameKit

struct Settings: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var gameViewModel: GameViewModel
    
    @State var showNotes = false
    
    var body: some View {
        
        Form {
            //Toggle Sound Effects
            Section {
                Toggle(isOn: $gameViewModel.isSoundEnabled) {
                    Text("Sound Effects")
                }
            } header: {
                Text("Game Settings")
                    .foregroundColor(Color("text-primary"))
            }
            
            //Show dev notes
            Section {
                Button {
                    showNotes = true
                } label: {
                    Text("Developer Notes")
                }
                
            } header: {
                Text("Misc")
                    .foregroundColor(Color("text-primary"))
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("darkBlue3"))
        .sheet(isPresented: $showNotes) {
            DevNotes()
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            GameCenterHelper.getAchievements(achievementId: "grp.BetaTesterAward", percent: 100.0)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(isPresented: .constant(true), gameViewModel: GameViewModel(mode: .easy))
    }
}
