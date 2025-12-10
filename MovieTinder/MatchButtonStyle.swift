//
//  matchButtonStyle.swift
//  MovieTinder
//
//  Created by Huthaifa Mohammad on 12/5/25.
//
import SwiftUI

struct MatchButtonStyle : ViewModifier{
    let color: Color = Color(red: 10/225, green: 20/255, blue: 60/225)
    func body(content: Content) -> some View {
        content
        .font(.custom("ArialRoundedMTBold", size: 30))
        .padding()
        .frame(width: 170, height: 55)
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}
extension View {
    func matchButtonStyle() -> some View {
        self.modifier(MatchButtonStyle())
    }
}
