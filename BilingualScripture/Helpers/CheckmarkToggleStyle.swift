//
//  CheckmarkToggleStyle.swift
//  BilingualScripture
//
//  Created by Mark Ho on 2024-05-17.
//

import SwiftUI

struct CheckmarkToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .accentColor : .gray)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.background)
                        .padding(.all, 3)
                        .overlay(
                            ZStack {
                                IconImage(systemName: "checkmark", isOn: configuration.isOn, visibleWhenOn: true)
                                IconImage(systemName: "xmark", isOn: configuration.isOn, visibleWhenOn: false)
                            }
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                )
                .cornerRadius(20)
                .onTapGesture {
                    withAnimation(.spring) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
    
    func IconImage(systemName: String, isOn: Bool, visibleWhenOn: Bool) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .font(Font.title.weight(.black))
            .frame(width: 8, height: 8, alignment: .center)
            .foregroundColor(isOn ? .accentColor : .gray)
            .opacity(isOn == visibleWhenOn ? 1 : 0)
    }
}
