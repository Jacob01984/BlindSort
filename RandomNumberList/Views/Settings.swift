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
                }
                Section {
                    Button {
                        showNotes = true
                    } label: {
                        Text("Developer Notes")
                    }
                } header: {
                    Text("Misc")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("background"))
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
