//
//  Gradients.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: Gradients Struct

struct Gradients {
    
    static let titleGradient = LinearGradient(gradient: Gradient(colors: [Color("GradientPurple"), Color("GradientOrange")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let cellGradient = LinearGradient(gradient: Gradient(colors: [Color("LightPurple"), Color("DarkPurple")]), startPoint: .topLeading, endPoint: .bottomTrailing)
}
