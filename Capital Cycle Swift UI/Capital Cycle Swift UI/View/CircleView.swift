//
//  CircleView.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 11/22/20.
//

import SwiftUI

struct CircleLoading: View {
    
    @State private var rotation: Double = 0
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            HStack {
                
                Spacer()
                
                ZStack {
                    
                    Circle()
                        .fill(color)
                        .frame(width: circleSize, height: circleSize)
                    
                    ForEach(0..<count) { i in
                        
                        Circle()
                            .trim(from: 0.0, to: 0.15 + CGFloat(i / count))
                            .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                            .frame(width: circleSize + 30 + CGFloat(i * 50), height: circleSize + 30 + CGFloat(i * 50))
                            .rotationEffect(.degrees(rotation))
                            .animation(Animation.linear(duration: 3.0 / Double(count - i)).repeatForever(autoreverses: false))
                    }
                }
                .onAppear() {
                    rotation = -360
                }
                
                Spacer()
            }
            Spacer()
        }
        
        .edgesIgnoringSafeArea(.all)
        .background(Color("ViewColor"))
    }

    // MARK: - Drawing constants
    let circleSize: CGFloat = 25
    let count: Int = 6
    let color = RadialGradient(gradient: Gradient(colors: [.orange, .green]), center: .center, startRadius: 0, endRadius: 150)
}

struct CircleLoading_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CircleLoading()
    }
}
