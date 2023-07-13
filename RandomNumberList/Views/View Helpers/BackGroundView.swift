//
//  BackGroundView.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/12/23.
//

import SwiftUI

struct BackGroundView: View {
    @State var ShowAnimation = true
    @State var start = UnitPoint(x: -2, y: 2)
    @State var end = UnitPoint(x: 2, y: -2)
    let colors = [Color("darkBlue3"), Color("lightBlue"), Color("darkBlue3"), Color("darkBlue2"), Color("lightBlue"), Color("darkBlue2")]
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors),
                       startPoint: ShowAnimation ? .topLeading : .bottomTrailing,
                       endPoint: .bottomLeading)
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 100).repeatForever(autoreverses: true).speed(8), value: ShowAnimation)
        .blur(radius: 80, opaque: true)
        .onAppear { ShowAnimation.toggle() }
    }
}

struct BackGroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackGroundView()
    }
}
