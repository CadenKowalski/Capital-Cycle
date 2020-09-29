//
//  FAQCellView.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/11/20.
//

import SwiftUI

// MARK: FAQCellView View

struct FAQCellView: View {
    
    var question: String
    var answer: String
    
    // MARK: View Construction
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Q: \(question)")
                .font(Font.custom("Avenir-Heavy", size: 23))
                .padding([.top, .leading, .trailing], 8)
            
            Text("A: \(answer)")
                .font(Font.custom("Avenir-Medium", size: 20))
                .padding(.all, 8)
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
struct FAQCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        FAQCellView(question: "When do you usually head out in the morning?", answer: "Around 10:00 - 10:30.")
            .previewLayout(.fixed(width: 400, height: 175))
    }
}
