//
//  LoginPage.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: Login Tab

struct Login: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var user: User
    @State var email = ""
    @State var password = ""
    @State var loginWasSuccessful = false
    @State var didRequestToSignUp = false
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            GradientView(title: "Log In", viewIsInSheet: false, viewIsInControlPage: false)
            
            VStack(spacing: 8) {
            
                CustomTextField(placeholderString: "Email", text: $email)
                    .cornerRadius(8)
                
                CustomTextField(placeholderString: "Password", text: $password)
                    .cornerRadius(8)
            }
            
            .padding([.leading, .trailing],  16)
            
            Button("Forgot your password?") {
            
            }
            
            .padding(.top, -8)
            .foregroundColor(.blue)
            .font(Font.custom("Avenir-Light", size: 14))
            
            HStack {
            
                Button(action: {
                    loginWasSuccessful = true
                }) {
                    Text("Log In")
                        .frame(width: 140, height: 45)
                        .background(Gradients.titleGradient)
                        .foregroundColor(.white)
                        .cornerRadius(22.5)
                        .font(Font.custom("Avenir-Heavy", size: 22))
                }
                
                .padding(.leading, 30)
                
                Spacer()
                
                SignInWithAppleButton(cornerRadius: 22.5, buttonStyle: .continue)
                    .frame(width: 140, height: 45)
                    .padding(.trailing, 30)
                
            }
            
            .padding(.top, 8)
            
            Spacer()
            
            VStack(spacing: 8) {
            
                Text("Don't have an account?")
                    .foregroundColor(Color("LabelColor"))
                
                Button(action: {
                    didRequestToSignUp = true
                }) {
                    Text("Sign Up")
                        .frame(width: 255, height: 33)
                        .background(Gradients.titleGradient)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(Font.system(size: 13, weight: .semibold))
                }
                
                SignInWithAppleButton(cornerRadius: 8, buttonStyle: .signUp)
                    .frame(width: 255, height: 33)
            }
            
            .padding(.bottom, 40)
        }
        
        .background(Color("ViewColor"))
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $loginWasSuccessful, content: {
            TabController().environmentObject(ViewModel())
        })
        
        .fullScreenCover(isPresented: $didRequestToSignUp) {
            SignUp()
        }
    }
}

// MARK: Preview

// Initializes the preview
struct LoginPage_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            Login().environmentObject(ViewModel())
                .previewDevice("iPod touch (7th generation)")
            
            Login().environmentObject(ViewModel())
                .previewDevice("iPhone 8")
            
            Login().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro")
            
            Login().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro Max")
        }
        
        .environment(\.colorScheme, .dark)
    }
}
