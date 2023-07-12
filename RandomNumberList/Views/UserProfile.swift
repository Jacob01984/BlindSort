//
//  UserProfile.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/11/23.
//

import SwiftUI



struct UserProfile: View {
    
    @Binding var showUserProfile: Bool
    
    var body: some View {
        
        
        HStack {
            Button {
                showUserProfile = false
            } label: {
                Image(systemName: "arrow.left")
            }

            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        
        
        
        
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(showUserProfile: .constant(true))
    }
}
