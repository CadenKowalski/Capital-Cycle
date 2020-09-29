//
//  AccountSettings.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: AccountSettings View

struct AccountSettings: View {
    
    var userTypes = ["Camper", "Parent", "Counselor"]
    @State var userTypeIndex = 0
    @State var hasEnabledGoogleAccess = false
    
    // Initializes the form with preferences
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            GradientView(title: "Account", viewIsInSheet: true, viewIsInControlPage: false)
            
            Image(systemName: "person.circle").resizable()
                .font(Font.title.weight(.light))
                .frame(width: 100, height: 100)
                .foregroundColor(Color("LabelColor"))
            
            Form {
                
                Section(header: Text("My Information")) {
                    
                    HStack {
                        
                        Text("Email")
                            
                        
                        Spacer()
                        
                        Text("cadenkowalski1@gmail.com")
                    }
                    
                    .font(Font.custom("Avenir-Medium", size: 18))
                    
                    HStack {
                        
                        Text("I am a")
                            .font(Font.custom("Avenir-Medium", size: 18))
                        
                        Spacer(minLength: 30)
                        
                        Picker("", selection: $userTypeIndex) {
                            ForEach(0 ..< userTypes.count) { index in
                                Text(userTypes[index])
                            }
                        }
                        
                        .padding(.trailing, -8)
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Section(header: Text("Linked Accounts")) {
                    
                    Toggle(isOn: $hasEnabledGoogleAccess) {
                        
                        Text("Google")
                            .font(Font.custom("Avenir-Medium", size: 18))
                        
                        Spacer()
                    }
                    
                    .toggleStyle(SwitchToggleStyle(tint: Color("LabelColor")))
                }
                
                Section(header: Text("Help")) {
                    
                    HStack {
                        
                        Text("Report a bug")
                            .font(Font.custom("Avenir-Medium", size: 18))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right").resizable()
                            .foregroundColor(.white)
                            .frame(width: 8.3, height: 14.7)
                    }
                    
                    HStack {
                        
                        Text("Suggest improvements")
                            .font(Font.custom("Avenir-Medium", size: 18))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right").resizable()
                            .foregroundColor(.white)
                            .frame(width: 8.3, height: 14.7)
                    }
                    
                    HStack {
                        
                        Text("Privacy Policy")
                            .font(Font.custom("Avenir-Medium", size: 18))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right").resizable()
                            .foregroundColor(.white)
                            .frame(width: 8.3, height: 14.7)
                    }
                }
            }
            
            .background(Color("ViewColor"))
        }
        
        .background(Color("ViewColor"))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Preview

// Initializesthe preview
struct AccountSettings_Previews: PreviewProvider {
    
    static var previews: some View {
        
        AccountSettings()
            .environment(\.colorScheme, .dark)
    }
}
