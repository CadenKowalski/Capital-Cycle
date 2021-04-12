//
//  GeneralSettings.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: GeneralSettings View

struct GeneralSettings: View {
    
    @State private var remainSignedIn = false
    @State private var prefersFaceIDToAuthenticate = false
    @State private var prefersHapticFeedback = false
    @State private var prefersNotifications = false
    
    // Initializes the form with preferences
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            GradientView(title: "Settings", viewIsInSheet: true, viewIsInControlPage: false)
            
            Text("PREFERENCES")
                .font(Font.system(size: 12))
                .padding([.top, .leading], 16)
            
            VStack(spacing: 4) {
            
                SettingsCellView(settingName: "Keep me signed in", toggleValue: $remainSignedIn)
                
                SettingsCellView(settingName: "Use Face ID to authenticate", toggleValue: $prefersFaceIDToAuthenticate)
                
                SettingsCellView(settingName: "Haptic Feedback", toggleValue: $prefersHapticFeedback)
            }
            
            Text("NOTIFICATIONS")
                .font(Font.system(size: 12))
                .padding([.top, .leading], 16)
            
            VStack(spacing: 4) {
            
                SettingsCellView(settingName: "Send me notifications", toggleValue: $prefersNotifications)
            }
            
            Spacer()
            
        }
        
        .background(Color("ViewColor"))
        .edgesIgnoringSafeArea(.all)

    }
}

// MARK: Preview

// Initializes the preview
struct GeneralSettings_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GeneralSettings()
            .environment(\.colorScheme, .dark)
    }
}
