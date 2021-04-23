//
//  TabController.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: TabController View

struct TabController: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var user: User
    
    // Initializes the tab controller with preferences
    init() {
        UITabBar.appearance().barTintColor = UIColor(named: "View")
        UITabBar.appearance().isTranslucent = false
    }
    
    // MARK: View Construction
    
    var body: some View {
        
        TabView {
            
            OverviewTab()
                .environmentObject(viewModel)
                .environmentObject(user)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Overview")
                }
            
            ScheduleTab()
                .environmentObject(viewModel)
                .environmentObject(user)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Schedule")
                }
            
            RegisterTab()
                .environmentObject(viewModel)
                .environmentObject(user)
                .tabItem {
                    Image(systemName: "dollarsign.square")
                    Text("Register")
                }
            
            FAQsTab()
                .environmentObject(viewModel)
                .environmentObject(user)
                .tabItem {
                    Image(systemName: "questionmark.square")
                    Text("FAQs")
                }
            
            CamperInfoTab()
                .environmentObject(viewModel)
                .environmentObject(user)
                .tabItem {
                    Image(systemName: "person.crop.square")
                    Text("Camper Info")
                }
        }
        
        .accentColor(Color.white)
    }
}

// MARK: Preview

// Initializes the preview
struct TabController_Previews: PreviewProvider {
    
    static var previews: some View {
        
        TabController().environmentObject(ViewModel())
    }
}
