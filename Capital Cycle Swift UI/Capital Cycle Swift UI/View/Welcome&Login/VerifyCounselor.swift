//
//  VerifyCounselor.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/11/20.
//

import SwiftUI

// MARK: VerifyCounselor View

struct VerifyCounselor: View {
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack {
            
            GradientView(title: "Verify Employment", viewIsInSheet: true, viewIsInControlPage: false)
            
            Spacer()
        }
        
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Preview

// Initializes the preview
struct VerifyCounselor_Previews: PreviewProvider {
    
    static var previews: some View {
        
        VerifyCounselor()
    }
}
