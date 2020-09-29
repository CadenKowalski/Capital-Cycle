//
//  RegisterCellView.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/11/20.
//

import SwiftUI

// MARK: RegisterCellView View

struct RegisterCellView: View {
    
    var image: String
    var product: String
    var price: String
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack {
            
            Image(image).resizable()
                .aspectRatio(0.97, contentMode: .fill)
                        
            Text(product)
            
            Text(price)
                .padding(.bottom, 8)
        }
        
        .font(Font.custom("Avenir-Book", size: 17))
        .foregroundColor(.white)
        .background(Color("LightPurple"))
        .cornerRadius(20)
    }
}

// MARK: Preview

// Initializes the preview
struct RegisterCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        RegisterCellView(image: "SessionImage", product: "Session 1 (4 days)", price: "from $375")
            .frame(width: 150, height: 250)
            .previewLayout(.fixed(width: 200, height: 275))
    }
}
