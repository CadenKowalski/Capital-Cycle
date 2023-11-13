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
    @State var didRequestToSignUp = false
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            GradientView(title: "Log In", viewIsInSheet: false, viewIsInControlPage: false)
            
            VStack(alignment: .leading) {
                
                HStack {
                    
                    Spacer()
                }
                
                Image("TransparentLogo")
                    .resizable()
                    .frame(width: 125, height: 125)
                    .padding(.bottom, 16)
                    .padding(.leading, -8)
                
                Text("Proceed with your")
                    .font(Font.custom("Avenir-Medium", size: 25))
                    .foregroundColor(Color("Label"))
                
                Text("Login")
                    .font(Font.custom("Avenir-Black", size: 30))
                    .foregroundColor(Color("Label"))
            }
            
            .padding(.leading, 24)
            .padding(.bottom, 20)
                        
            VStack(spacing: 8) {
            
                CustomTextField(placeholderString: "Email", text: $email)
                    .cornerRadius(8)
                
                CustomTextField(placeholderString: "Password", isSecure: true, text: $password)
                    .cornerRadius(8)
            }
            
            .padding([.leading, .trailing],  16)
            
            HStack {
            
                Button(action: {
                    
                    user.isSignedIn = true
                }) {
                    
                    Text("Log In")
                        .frame(width: 140, height: 45)
                        .background(Gradients.titleGradient)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(Font.custom("Avenir-Heavy", size: 22))
                }
            }
                        
            Button("Forgot your password?") {
            
            }
            
            .foregroundColor(.blue)
            .font(Font.custom("Avenir-Light", size: 14))

            
            Spacer()
            
            VStack(spacing: 8) {
            
                Text("Don't have an account?")
                    .foregroundColor(Color("Label"))
                
                Button(action: {
                    
                    didRequestToSignUp = true
                }) {
                    
                    Text("Sign Up")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 45)
                        .background(Gradients.titleGradient)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(Font.system(size: 18, weight: .semibold))
                }
            }
            
            .padding([.leading, .trailing], 24)
            .padding(.bottom, 40)
        }
        
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $user.isSignedIn, content: {
            TabController()
                .environmentObject(viewModel)
                .environmentObject(user)
        })
        
        .fullScreenCover(isPresented: $didRequestToSignUp) {
            SignUp()
                .environmentObject(viewModel)
                .environmentObject(user)
        }
    }
}

// MARK: Preview

// Initializes the preview
struct LoginPage_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            //Login().environmentObject(ViewModel())
                //.previewDevice("iPod touch (7th generation)")
            
            //Login().environmentObject(ViewModel())
                //.previewDevice("iPhone 8")
            
            Login()
                .environmentObject(User())
                .environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro")
            
            //Login().environmentObject(ViewModel())
                //.previewDevice("iPhone 11 Pro Max")
        }
        
        .environment(\.colorScheme, .dark)
    }
}
