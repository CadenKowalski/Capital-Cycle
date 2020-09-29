//
//  VerifyUser.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/11/20.
//

import SwiftUI

// MARK: VerifyUser View

struct VerifyUser: View {
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack {
            
            GradientView(title: "Verify Email", viewIsInSheet: true, viewIsInControlPage: false)
            
            Spacer()
        }
        
        .background(Color("ViewColor"))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Preview

// Initializes the preview
struct VerifyUser_Previews: PreviewProvider {
    
    static var previews: some View {
        
        VerifyUser()
    }
}
