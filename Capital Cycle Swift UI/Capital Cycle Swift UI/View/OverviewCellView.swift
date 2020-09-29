//
//  OverviewCellView.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: OverciewCellView View

struct OverviewCellView: View {
    
    var title: String
    var text: String
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            let textView = Text(text)
                .font(Font.custom("Avenir-Medium", size: 20))
            
            Text(title)
                .font(Font.custom("Avenir-Heavy", size: 23))
                .padding([.top, .leading], 8)
            
            if title == "Camp Location:" {
                textView
                    .underline()
                    .padding([.top, .bottom], 8)
                    .padding(.leading, 32)
            } else {
                textView
                    .padding([.top, .bottom], 8)
                    .padding(.leading, 32)
            }
        }
        
        .frame(width: UIScreen.main.bounds.width - 16, alignment: .leading)
        .foregroundColor(.white)
        .background(Gradients.cellGradient)
        .cornerRadius(20)
        .shadow(color: Color("ShadowColor"), radius: 5)
    }
}

// MARK: Preview

// Initializes the preview
struct GradientCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        OverviewCellView(title: "Camp Hours:", text: "9AM - 6PM\nOR\n8AM - 6PM with before care")
            .previewLayout(.fixed(width: 400, height: 175))
    }
}
