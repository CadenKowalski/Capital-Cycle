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
        
        VStack(spacing: 24) {
            
            GradientView(title: "Account", viewIsInSheet: true, viewIsInControlPage: false)
            
            Image(systemName: "person.circle").resizable()
                .font(Font.title.weight(.light))
                .frame(width: 100, height: 100)
                .foregroundColor(Color("LabelColor"))
            
            VStack(alignment: .leading) {
                
                Text("MY INFORMATAION")
                    .font(Font.system(size: 12))
                
                VStack(spacing: 4) {
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 45)
                            .foregroundColor(Color("TextFieldColor"))
                        
                        HStack {
                            
                            Text("Email")
                                .font(Font.custom("Avenir-Medium", size: 18))
                            
                            Spacer()
                            
                            Text("cadenkowalski1@gmail.com")
                                .font(Font.custom("Avenir-Medium", size: 18))
                        }
                        
                        .padding([.leading, .trailing], 16)
                    }
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 45)
                            .foregroundColor(Color("TextFieldColor"))
                        
                        HStack {
                            
                            Text("I am a")
                                .font(Font.custom("Avenir-Medium", size: 18))
                            
                            Spacer(minLength: 32)
                            
                            Picker("", selection: $userTypeIndex) {
                                
                                ForEach(0 ..< userTypes.count) { index in
                                    
                                    Text(userTypes[index])
                                }
                            }
                            
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        .padding(.leading, 16)
                        .padding(.trailing, 8)
                    }
                }
            }
            
            .padding([.leading, .trailing], 16)
            
            VStack(alignment: .leading) {
                
                Text("LINKED ACCOUNTS")
                    .font(Font.system(size: 12))
                    .padding([.leading, .trailing], 16)
                                    
                SettingsCellView(settingName: "Google", toggleValue: $hasEnabledGoogleAccess)
            }
                        
            VStack(alignment: .leading) {
                
                Text("HELP")
                    .font(Font.system(size: 12))
                
                VStack(spacing: 4) {
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 45)
                            .foregroundColor(Color("TextFieldColor"))
                        
                        HStack {
                            
                            Text("Report a bug")
                                .font(Font.custom("Avenir-Medium", size: 18))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right").resizable()
                                .foregroundColor(.white)
                                .frame(width: 8.3, height: 14.7)
                        }
                        
                        .padding([.leading, .trailing], 16)
                    }
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 45)
                            .foregroundColor(Color("TextFieldColor"))
                        
                        HStack {
                            
                            Text("Suggested Improvements")
                                .font(Font.custom("Avenir-Medium", size: 18))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right").resizable()
                                .foregroundColor(.white)
                                .frame(width: 8.3, height: 14.7)
                        }
                        
                        .padding([.leading, .trailing], 16)
                    }
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 45)
                            .foregroundColor(Color("TextFieldColor"))
                        
                        HStack {
                            
                            Text("Privacy Policy")
                                .font(Font.custom("Avenir-Medium", size: 18))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right").resizable()
                                .foregroundColor(.white)
                                .frame(width: 8.3, height: 14.7)
                        }
                        
                        .padding([.leading, .trailing], 16)
                    }
                }
            }
            
            .padding([.leading, .trailing], 16)
            
            Spacer()
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
