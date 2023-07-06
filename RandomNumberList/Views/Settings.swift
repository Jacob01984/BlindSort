//
//  Settings.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/3/23.
//

import SwiftUI

struct Settings: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var gameViewModel: GameViewModel
    
    @State var showNotes = false
    
    var body: some View {
        
        Form {
            Section {
                Toggle(isOn: $gameViewModel.isSoundEnabled) {
                    Text("Sound Effects")
                }
            } header: {
                Text("Settings")
                    .foregroundColor(Color("text-primary"))
            }
            
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
        .background(Color("darkBlue2"))
        .sheet(isPresented: $showNotes) {
            DevNotes()
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(isPresented: .constant(true), gameViewModel: GameViewModel(mode: .easy))
    }
}
