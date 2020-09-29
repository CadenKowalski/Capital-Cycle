//
//  FAQCategoryView.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/11/20.
//

import SwiftUI

// FAQCategoryView View

struct FAQCategoryView: View {
    
    var categoryName: String
    var isSelected: Bool
    
    // MARK: View Construction
    
    var body: some View {
        
        let category = Text(categoryName)
            .font(Font.custom("Avenir-Book", size: 17))
            .foregroundColor(.white)
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 6)
        
        if isSelected {
            category
                .background(Gradients.titleGradient)
                .cornerRadius(16)
        } else {
            category
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white, lineWidth: 0.5)
                )
        }
    }
}

// MARK: Preview

// Initializes the preview
struct FAQCategoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            FAQCategoryView(categoryName: "All", isSelected: true)
            
            FAQCategoryView(categoryName: "All", isSelected: false)
        }
        
        .previewLayout(.fixed(width: 100, height: 100))
    }
}
