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
    @State  var confirmPassword = ""
    @State var userTypeIndex = 0
    @State var inputsAreValid = false
    @State var openPrivacyPolicy = false
    @State var hasAgreedToPrivacyPolicy = false
    
    // Initializes the form with preferences
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
    }
    
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            GradientView(title: "Sign Up", viewIsInSheet: true, viewIsInControlPage: false)
                        
            Form {
                
                Section {
                    
                    HStack {
                        
                        Spacer()
                        
                        Image(systemName: "person.circle").resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .font(Font.title.weight(.light))
                        
                        Spacer()
                    }
                }
                
                .listRowBackground(Color("ViewColor"))
                
                Section(header: Text("My Information")) {
                    
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textContentType(.password)
                    
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
                
                Section(header: Text("Preferences")) {
                    
                    Toggle(isOn: $viewModel.remainSignedIn) {
                        
                        Text("Keep me signed in")
                            .font(Font.custom("Avenir-Medium", size: 18))
                    }
                }
                
                Section(header: Text("Privacy Policy")) {
                    
                    HStack {
                        
                        Text("Privacy Policy")
                            .font(Font.custom("Avenir-Medium", size: 18))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right").resizable()
                            .foregroundColor(.white)
                            .frame(width: 8.3, height: 14.7)
                    }
                    
                    .onTapGesture(count: 1, perform: {
                        openPrivacyPolicy = true
                    })
                    
                    .sheet(isPresented: $openPrivacyPolicy, content: {
                        PrivacyPolicy()
                    })
                    
                    Toggle(isOn: $hasAgreedToPrivacyPolicy) {
                        
                        Text("I have read and agree to the privacy policy as stated above")
                            .font(Font.custom("Avenir-Medium", size: 18))
                    }
                }
                
                Section {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            inputsAreValid = true
                        }) {
                            Text("Continue")
                                .frame(width: 140, height: 45)
                                .background(Gradients.titleGradient)
                                .foregroundColor(.white)
                                .cornerRadius(22.5)
                                .font(Font.system(size: 20, weight: .medium))
                        }
                        
                        .sheet(isPresented: $inputsAreValid) {
                            if userTypeIndex == 2 {
                                VerifyCounselor()
                            } else {
                                VerifyUser()
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                .listRowBackground(Color("ViewColor"))
            }
            
            .toggleStyle(SwitchToggleStyle(tint: Color("LabelColor")))
            .padding(.top, -8)
        }
        
        .foregroundColor(Color("LabelColor"))
        .background(Color("ViewColor"))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Preview

// Initializes the preview
struct SignUp_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            SignUp()
                .previewDevice("iPod touch (7th generation)")
            
            SignUp()
                .previewDevice("iPhone 8")
            
            SignUp()
                .previewDevice("iPhone 11 Pro")
            
            SignUp()
                .previewDevice("iPhone 11 Pro Max")
        }
        
        .environment(\.colorScheme, .dark)
    }
}
