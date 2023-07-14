//
//  CustomAlert.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 7/14/23.
//

import SwiftUI

struct CustomAlert: View {
    
    @Binding var isPresented: Bool
    var title: String = "Game Won!"
    var message: String = "Nice job, Can you do it again?"
    var leftButtonLabel: String = "Cancel"
    var rightButtonLabel: String = "Next"
    var leftButtonAction: (() -> ())
    var rightButtonAction: (() -> ())
    
    var body: some View {
            
            VStack {
                    Text(title)
                        .font(.title2)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    Divider()
                    GeometryReader { geo in
                        HStack(alignment: .center) {
                            Button {
                                leftButtonAction()
                            } label: {
                                Text(leftButtonLabel)
                                    .font(.title2)
                            }
                            .frame(width: geo.size.width * 0.50, height: geo.size.height * 0.3)
                            Divider()
                            Button {
                                rightButtonAction()
                                
                            } label: {
                                Text(rightButtonLabel)
                                    .font(.title2)
                            }
                            .frame(width: geo.size.width * 0.50, height: geo.size.height * 0.3)
                        }
                        .frame(width: geo.size.width * 1.0, height: geo.size.height * 0.8)
                    }
                    
                    Spacer()
                }
                .frame(width: 300, height: 125)
                .background(.regularMaterial)
                .cornerRadius(10)
    }
}









struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(isPresented: .constant(false), leftButtonAction: {}, rightButtonAction: {})
    }
}
