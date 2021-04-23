//
//  WelcomePageViews.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 4/22/21.
//

import SwiftUI

extension AnyTransition {
    
    static var slideLeading: AnyTransition {
        
        let insertion = AnyTransition.move(edge: .trailing)
        let removal = AnyTransition.move(edge: .leading)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}


struct Intro: View {
    
    @EnvironmentObject var viewModel: ViewModel
            
    var body: some View {
        
        VStack {
            
            Text("Welcome to\nCapital Cycle")
                .font(Font.custom("Avenir-Black", size: 56))
                .multilineTextAlignment(.center)
                .foregroundColor(Color("Label"))
                .padding(.bottom, 24)
            
            Text("Create an account to:")
                .font(Font.custom("Avenir-Heavy", size: 25))
                .foregroundColor(Color("Label"))
            
            ForEach(viewModel.welcomeCells) { informationCell in
                 
                 WelcomeCellView(symbol: informationCell.symbol, title: informationCell.title, description: informationCell.description)
                
                    .padding(.bottom, 16)
            }
            
            HStack {
                
                Text("* = counselors only")
                    .font(Font.custom("Avenir-light", size: 14))
                    .foregroundColor(Color("Label"))
                
                Spacer()
            }
            
            .padding(.leading, 25)
            .padding(.top, -8)
        }
        
        .transition(.slideLeading)
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct Who: View {
    
    var userTypes = ["Camper", "Parent", "Counselor"]
    @State var userTypeIndex = 0
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "MidGradient")
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                
                Text("What kind of user are you?")
                    .foregroundColor(Color("Label"))
                    .font(Font.custom("Avenir-Black", size: 25))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            
            Text("(This will help us tailor your experience)")
                .foregroundColor(Color("Label"))
                .font(Font.custom("Avenir-Medium", size: 14))
                .padding(.bottom, 24)
            
            Picker("", selection: $userTypeIndex) {
                
                ForEach(0 ..< userTypes.count) { index in
                    
                    Text(userTypes[index])
                }
            }
            
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 24)
            .padding([.leading, .trailing], 16)
            
            if userTypeIndex == 0 {
                
                WelcomeCellView(symbol: "mappin.and.ellipse", title: "Navigate to Camp", description: "Campers will be able to easily view directions to the camp site.")
                
                WelcomeCellView(symbol: "calendar", title: "See Activities", description: "Campers will be able to view what upcoming days have in store as well as reflect back on days throughout the week.")
                
                WelcomeCellView(symbol: "questionmark.diamond", title: "View FAQ", description: "Campers will be able to view the answers to FAQ in order to better understand how camp operates.")
            }
            
            if userTypeIndex == 1 {
                
                WelcomeCellView(symbol: "signature", title: "Register For Camp", description: "Parents will be able to view information about upcoming sessions and register their children for camp.")
                
                WelcomeCellView(symbol: "person.fill.questionmark", title: "Contact Counselors", description: "Parents will be able to contact counselors directly as well as submit questions to the FAQ.")
                
                WelcomeCellView(symbol: "envelope", title: "Recieve Important Information", description: "Parents have the option to recieve important updates regarding camp activities, required items for a given activity, and camp policy.")
            }
            
            if userTypeIndex == 2 {
                
                WelcomeCellView(symbol: "person", title: "Access Contact Information*", description: "Counselors will have access to emergency contact information as well as any allergies or special needs campers may have.")
                
                WelcomeCellView(symbol: "pencil", title: "Set and Change Activities*", description: "Counselors will have the ability to set a day's schedule as well as modify it in the event of unexpected changes such as unfavorable weather.")
                
                HStack {
                    
                    Text("* = counselors only")
                        .font(Font.custom("Avenir-light", size: 14))
                        .foregroundColor(Color("Label"))
                    
                    Spacer()
                }
                
                .padding(.leading, 16)
            }
        }
        
        .transition(.slideLeading)
        .padding(.top, 70)
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct Info: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var user: User
    @State var password = ""
    @State var confirmPassword = ""
    @State var inputsAreValid = false
    @State var openPrivacyPolicy = false
    @State var userHasAgreedToPrivacyPolicy = false
    @State var signUpErrors: [AuthenticationFunctions.signUpError] = [.none]
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                Text("What login would you like?")
                    .foregroundColor(Color("Label"))
                    .font(Font.custom("Avenir-Black", size: 25))
                    .multilineTextAlignment(.center)
                
                Text("(You can change things later in settins)")
                    .foregroundColor(Color("Label"))
                    .font(Font.custom("Avenir-Medium", size: 14))
                    .padding(.bottom, 24)
                
                CustomTextField(placeholderString: "Email", text: $viewModel.email)
                    .foregroundColor(signUpErrors.contains(.emailIsNotValid) ? Color.red.opacity(0.3) : Color.clear)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .stroke(signUpErrors.contains(.emailIsNotValid) ? Color.red.opacity(0.3) : Color.clear, lineWidth: 5)
                    )
                
                CustomTextField(placeholderString: "Password", isSecure: true, text: $password)
                    .textContentType(.newPassword)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(signUpErrors.contains(.passwordsDoNotMatch) || signUpErrors.contains(.passwordIsNotValid) ? Color.red.opacity(0.3) : Color.clear, lineWidth: 5)
                    )
                
                CustomTextField(placeholderString: "Confirm Password", isSecure: true, text: $confirmPassword)
                    .textContentType(.newPassword)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .stroke(signUpErrors.contains(.passwordsDoNotMatch) ? Color.red.opacity(0.3) : Color.clear, lineWidth: 5)
                    )
                
                Text("Must be at least 6 chatacters long, contain both cases, and use either a number or a symbol.")
                    .font(Font.custom("Avenir-Medium", size: 14))
                    .foregroundColor(Color("Label"))
                    .padding([.leading, .trailing], 4)
            }
            
            .padding([.leading, .trailing], 16)
            .padding(.top, 24)
            
            VStack {
                
                SettingsCellView(settingName: "Keep me signed in", toggleValue: $viewModel.remainSignedIn)
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 45)
                        .foregroundColor(Color("TextField"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .stroke(signUpErrors.contains(.userHasNotAgreedToPrivacyPolicy) ? Color.red.opacity(0.3) : Color.clear, lineWidth: 5)
                        )
                    
                    HStack {
                        
                        Text("Privacy Policy")
                            .font(Font.custom("Avenir-Medium", size: 18))
                            .foregroundColor(Color("Label"))
                        
                        Rectangle()
                            .frame(height: 40)
                            .foregroundColor(Color("TextField"))
                        
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
            
            Spacer()
        }
        
        .transition(.slideLeading)
        .padding(.top, 70)
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $openPrivacyPolicy, content: {
            PrivacyPolicy()
        })
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

struct ProfileImage: View {
            
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                
                Text("(Replace with profile image)")
                    .foregroundColor(Color("Label"))
                    .font(Font.custom("Avenir-Black", size: 25))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
        
        .transition(.slideLeading)
        .padding([.leading, .trailing], 16)
        .padding(.top, 70)
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct Verification: View {
            
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                
                Text("(Replace with email/ counselor verification logic)")
                    .foregroundColor(Color("Label"))
                    .font(Font.custom("Avenir-Black", size: 25))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
        
        .transition(.slideLeading)
        .padding([.leading, .trailing], 16)
        .padding(.top, 70)
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct Complete: View {
            
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                
                Text("You are all set!")
                    .foregroundColor(Color("Label"))
                    .font(Font.custom("Avenir-Black", size: 35))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 100, height: 100)
                .gradientForeground(colors: [Color("GradientPurple"), Color("GradientOrange")])
        }
        
        .transition(.slideLeading)
        .padding(.top, 70)
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct WelcomePageViews_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Intro()
            .environmentObject(ViewModel())
        
        Who()
            .preferredColorScheme(.dark)
                
        Info()
            .environmentObject(ViewModel())
        
        ProfileImage()
        
        Verification()
        
        Complete()
    }
}
