//
//  PrivacyPolicy.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/11/20.
//

import SwiftUI

// MARK: PrivacyPolicy View

struct PrivacyPolicy: View {
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            GradientView(title: "Privacy Policy", viewIsInSheet: true, viewIsInControlPage: false)
            
            Text("  This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy This will be the privacy policy")
                .foregroundColor(Color("Label"))
                .font(Font.custom("Avenir-Book", size: 13))
                .padding([.leading, .trailing], 8)
            
            Spacer()
        }
        
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Preview

// Initializes the preview
struct PrivacyPolicy_Previews: PreviewProvider {
    
    static var previews: some View {
        
        PrivacyPolicy()
    }
}
