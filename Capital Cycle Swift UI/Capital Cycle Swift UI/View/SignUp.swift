//
//  SignUp.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: SignUp View

struct SignUp: View {
    
    @EnvironmentObject var viewModel: ViewModel
    var userTypes = ["Camper", "Parent", "Counselor"]
    @State var password = ""
    @State var confirmPassword = ""
    @State var userTypeIndex = 0
    @State var inputsAreValid = false
    @State var openPrivacyPolicy = false
    @State var userHasAgreedToPrivacyPolicy = false
    @State var signUpErrors: [AuthenticationFunctions.signUpError] = [.none]
    
    // Initializes the form with preferences
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().sectionHeaderHeight = 5
    }
    
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            GradientView(title: "Sign Up", viewIsInSheet: false, viewIsInControlPage: false)
            
            Image(systemName: "person.circle").resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(Color("LabelColor"))
                .font(Font.title.weight(.light))
            
            VStack {
                
                ZStack {
                    
                    CustomTextField(placeholderString: "Email", text: $viewModel.email)
                        .foregroundColor(signUpErrors.contains(.emailIsNotValid) ? Color.red.opacity(0.3) : Color.clear)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .stroke(signUpErrors.contains(.emailIsNotValid) ? Color.red.opacity(0.3) : Color.clear, lineWidth: 5)
                        )
                }
                
                
                
                CustomTextField(placeholderString: "Password", text: $password)
                    .textContentType(.newPassword)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(signUpErrors.contains(.passwordsDoNotMatch) || signUpErrors.contains(.passwordIsNotValid) ? Color.red.opacity(0.3) : Color.clear, lineWidth: 5)
                    )
                
                CustomTextField(placeholderString: "Confirm Password", text: $confirmPassword)
                    .textContentType(.newPassword)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .stroke(signUpErrors.contains(.passwordsDoNotMatch) ? Color.red.opacity(0.3) : Color.clear, lineWidth: 5)
                    )
                
                Text("Must be at least 6 chatacters long, contain both cases, and use either a number or a symbol.")
                    .font(Font.custom("Avenir-Medium", size: 14))
                    .foregroundColor(Color("LabelColor"))
                    .padding([.leading, .trailing], 4)
            }
            
            .padding([.leading, .trailing], 16)
            
            VStack {
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 45)
                        .foregroundColor(Color("TextFieldColor"))
                    
                    HStack {
                        
                        Text("I am a")
                            .font(Font.custom("Avenir-Medium", size: 18))
                            .foregroundColor(Color("LabelColor"))
                        
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
                
                .padding([.leading, .trailing], 16)
                
                SettingsCellView(settingName: "Keep me signed in", toggleValue: $viewModel.remainSignedIn)
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 45)
                        .foregroundColor(Color("TextFieldColor"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .stroke(signUpErrors.contains(.userHasNotAgreedToPrivacyPolicy) ? Color.red.opacity(0.3) : Color.clear, lineWidth: 5)
                        )
                    
                    HStack {
                        
                        Text("Privacy Policy")
                            .font(Font.custom("Avenir-Medium", size: 18))
                            .foregroundColor(Color("LabelColor"))
                        
                        Rectangle()
                            .frame(height: 40)
                            .foregroundColor(Color("TextFieldColor"))
                        
                        Image(systemName: "chevron.right").resizable()
                            .foregroundColor(.white)
                            .frame(width: 8.3, height: 14.7)
                    }
                    
                    .padding([.leading, .trailing], 16)
                    .onTapGesture(count: 1, perform: {
                        
                        userHasAgreedToPrivacyPolicy = true
                        openPrivacyPolicy = true
                    })
                }
                
                .padding([.leading, .trailing], 16)
            }
            
            .sheet(isPresented: $openPrivacyPolicy, content: {
                PrivacyPolicy()
            })
            
            Button(action: {
                        
                verifyInputs()
            }) {
                        
                Text("Continue")
                    .frame(width: 140, height: 45)
                    .background(Gradients.titleGradient)
                    .foregroundColor(.white)
                    .cornerRadius(22.5)
                    .font(Font.system(size: 20, weight: .medium))
            }
            
            .offset(y: 120)
            .sheet(isPresented: $inputsAreValid) {
                if userTypeIndex == 2 {
                            
                    VerifyCounselor()
                } else if viewModel.type != .admin {
                    
                    VerifyUser()
                } else {
                    
                    TabController()
                }
            }
            
            Spacer()
        }
        
        .background(Color("ViewColor"))
        .edgesIgnoringSafeArea(.all)
    }
    
    func verifyInputs() {
        
        if viewModel.email == "cadenkowalski1@gmail.com" || viewModel.email == "tester@test.com" {
            
            viewModel.type = .admin
            viewModel.isCounselorVerified = true
        }

        signUpErrors = viewModel.verifyInputs(email: viewModel.email, password: password, confirmPassword: confirmPassword, userHasAgreedToPrivacyPolicy: userHasAgreedToPrivacyPolicy)
        if signUpErrors == [AuthenticationFunctions.signUpError.none] {
            inputsAreValid = true
        }
    }
}

// MARK: Preview

// Initializes the preview
struct SignUp_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            SignUp().environmentObject(ViewModel())
                .previewDevice("iPod touch (7th generation)")
            
            SignUp().environmentObject(ViewModel())
                .previewDevice("iPhone 8")
            
            SignUp().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro")
            
            SignUp().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro Max")
        }
        
        .environment(\.colorScheme, .dark)
    }
}
