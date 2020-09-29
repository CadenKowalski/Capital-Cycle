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
        
        VStack(spacing: 0) {
            
            GradientView(title: "Settings", viewIsInSheet: true, viewIsInControlPage: false)
            
            Form {
                
                Section(header: Text("Preferences")) {
                    
                    Toggle(isOn: $remainSignedIn) {
                        
                        Text("Keep me signed in")
                            .font(Font.custom("Avenir-Medium", size: 18))
                    }
                    
                    Toggle(isOn: $prefersFaceIDToAuthenticate) {
                        
                        Text("Use Face ID to authenticate")
                            .font(Font.custom("Avenir-Medium", size: 18))
                    }
                    
                    Toggle(isOn: $prefersHapticFeedback) {
                        
                        Text("Haptic Feedback")
                            .font(Font.custom("Avenir-Medium", size: 18))
                    }
                }
                
                Section(header: Text("Notifications")) {
                    
                    Toggle(isOn: $prefersNotifications) {
                        
                        Text("Send me notifications")
                            .font(Font.custom("Avenir-Medium", size: 18))
                    }
                }
            }
            
            .padding(.top, 8)
            .background(Color("ViewColor"))
            .toggleStyle(SwitchToggleStyle(tint: Color("LabelColor")))
        }
        
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
