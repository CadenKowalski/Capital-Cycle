//
//  CamperInfoTab.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: CamperInfoTab Tab

struct CamperInfoTab: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var user: User
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack {
            
            GradientView(title: "Camper Info", viewIsInSheet: false, viewIsInControlPage: true)
                .environmentObject(viewModel)
                .environmentObject(user)
            
            Spacer()
        }
        
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Preview

// Initializes the preview
struct CamperInfoTab_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            CamperInfoTab().environmentObject(ViewModel())
                .previewDevice("iPod touch (7th generation)")
            
            CamperInfoTab().environmentObject(ViewModel())
                .previewDevice("iPhone 8")
            
            CamperInfoTab().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro")
            
            CamperInfoTab().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro Max")
        }
        
        .environment(\.colorScheme, .dark)
    }
}
