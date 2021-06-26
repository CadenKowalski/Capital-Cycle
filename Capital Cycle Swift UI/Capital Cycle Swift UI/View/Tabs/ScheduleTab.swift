//
//  ScheduleTab.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: ScheduleTab Tab

struct ScheduleTab: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var user: User
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack {
            
            GradientView(title: "Schedule", viewIsInSheet: false, viewIsInControlPage: true)
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
struct ScheduleTab_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
        
            ScheduleTab().environmentObject(ViewModel())
                .previewDevice("iPod touch (7th generation)")
            
            ScheduleTab().environmentObject(ViewModel())
                .previewDevice("iPhone 8")
            
            ScheduleTab().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro")
            
            ScheduleTab().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro Max")
        }
        
        .environment(\.colorScheme, .dark)
    }
}