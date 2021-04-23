//
//  WelcomeCellView.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 4/21/21.
//

import SwiftUI

extension View {
    
    public func gradientForeground(colors: [Color]) -> some View {
        
        self.overlay(LinearGradient(gradient: .init(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(self)
    }
}

struct WelcomeCellView: View {
    
    var symbol: String
    var title: String
    var description: String
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "\(symbol)").resizable()
                .gradientForeground(colors: [Color("GradientPurple"), Color("GradientOrange")])
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .font(Font.title.weight(.semibold))
                .padding(.leading, 24)
                .padding(.trailing, 16)
            
            VStack(alignment: .leading) {
                
                Text("\(title)")
                    .font(Font.custom("Avenir-Heavy", size: 18))
                    .foregroundColor(Color("Label"))
                
                Text("\(description)")
                    .font(Font.custom("Avenir-medium", size: 16))
                    .foregroundColor(Color("WelcomeText"))
            }

            Spacer()
        }
        
        .background(Color("View"))
    }
}

struct WelcomeCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        WelcomeCellView(symbol: "person", title: "Create an Account", description: "Never forget what to pack when switching houses. Add and remove items depending on what you need each week.")
    }
}
