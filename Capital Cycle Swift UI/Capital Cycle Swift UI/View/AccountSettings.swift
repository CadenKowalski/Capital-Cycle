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
    @EnvironmentObject var user: User
    @Binding var isPresented: Bool
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            GradientView(title: "Account", viewIsInSheet: true, viewIsInControlPage: false)
            
            ScrollView {
                
                VStack(spacing: 24) {
                    
                    Image(systemName: "person.circle").resizable()
                        .font(Font.title.weight(.light))
                        .frame(width: 100, height: 100)
                        .padding(.top, 16)
                        .foregroundColor(Color("Label"))
                    
                    VStack(alignment: .leading) {
                        
                        Text("MY INFORMATAION")
                            .font(Font.system(size: 12))
                        
                        VStack(spacing: 4) {
                            
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 45)
                                    .foregroundColor(Color("TextField"))
                                
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
                                    .foregroundColor(Color("TextField"))
                                
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
                        
                        Text("HELP\n\n* As a 16 year old, I simply cannot make everything perfect. If you have any trouble with the app, please let me know\n\n* Alternatively, if you ave any suggestions to improve the app or user experience, please let me know as well")
                            .font(Font.system(size: 12))
                        
                        VStack(spacing: 4) {
                            
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 45)
                                    .foregroundColor(Color("TextField"))
                                
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
                                    .foregroundColor(Color("TextField"))
                                
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
                                    .foregroundColor(Color("TextField"))
                                
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
                    
                    VStack(spacing: 4) {
                        
                        Button(action: {
                                    
                            isPresented = false
                            user.isSignedIn = false
                        }) {
                                    
                            Text("Log Out")
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(Color("DestructiveRed"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding([.leading, .trailing], 16)
                                .opacity(0.85)
                                .font(Font.custom("Avenir-Medium", size: 20))
                        }
                        
                        Button(action: {
                                    
                            
                        }) {
                                    
                            Text("Reset Password")
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(Color("DestructiveRed"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding([.leading, .trailing], 16)
                                .opacity(0.85)
                                .font(Font.custom("Avenir-Medium", size: 20))                        }
                        
                        Button(action: {
                                    
                            
                        }) {
                                    
                            Text("Delete my Account")
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(Color("DestructiveRed"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding([.leading, .trailing], 16)
                                .opacity(0.85)
                                .font(Font.custom("Avenir-Medium", size: 20))
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Preview

// Initializesthe preview
/*struct AccountSettings_Previews: PreviewProvider {
    
    static var previews: some View {
        
        AccountSettings(isPresented: $presented)
            .environment(\.colorScheme, .dark)
    }
}*/
