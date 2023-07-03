//
//  DevNotes.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/3/23.
//

import SwiftUI

struct DevNotes: View {
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            VStack {
                Text("""
                Thank You For Downloading my first app that made it to the App Store!
                
                As an aspiring IOS Developer, it would mean alot if you would submit a review for the app.
                
                As the app currently sits, there are no ads or any sort of monetization, which is quite rare theses days.
                
                If you would like to connect, my socials will be down below!
                
                """)
                
                HStack {
                    Button(action: {
                        if let url = URL(string: "https://www.instagram.com/jacoblavenant/") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image("instagram")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                    Button(action: {
                        if let url = URL(string: "https://github.com/Jacob01984") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image("github")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                    Button(action: {
                        if let url = URL(string: "https://www.linkedin.com/in/jacob-lavenant-094612251/") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image("linkedin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                }
                Spacer()
            }
            .padding(.top, 50)
            .padding(.horizontal)
        }
    }
}

struct DevNotes_Previews: PreviewProvider {
    static var previews: some View {
        DevNotes()
    }
}
