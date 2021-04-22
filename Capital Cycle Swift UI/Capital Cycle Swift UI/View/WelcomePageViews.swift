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
                .padding(.bottom, 30)
            
            ForEach(viewModel.welcomeCells) { informationCell in
                 
                 WelcomeCellView(symbol: informationCell.symbol, title: informationCell.title, description: informationCell.description)
                
                Spacer()
            }
        }
        
        .transition(.slideLeading)
        .animation(.linear(duration: 0.5))
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
                .font(Font.custom("Avenir-Black", size: 14))
                .padding(.bottom, 24)
            
            Picker("", selection: $userTypeIndex) {
                
                ForEach(0 ..< userTypes.count) { index in
                    
                    Text(userTypes[index])
                }
            }
            
            .pickerStyle(SegmentedPickerStyle())
        }
        
        .transition(.slideLeading)
        .animation(.linear(duration: 0.5))
        .padding([.leading, .trailing], 16)
        .padding(.top, 70)
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct Method: View {
            
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                
                Text("How would you like to sign up?")
                    .foregroundColor(Color("Label"))
                    .font(Font.custom("Avenir-Black", size: 25))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            
            .padding(.bottom, 24)
            
            Text("Email (replace with button)")
                .foregroundColor(Color("Label"))
                .font(Font.custom("Avenir-Black", size: 20))
                .padding(.bottom, 8)
            
            Text("Sign Up With Apple")
                .foregroundColor(Color("Label"))
                .font(Font.custom("Avenir-Black", size: 20))
        }
        
        .transition(.slideLeading)
        .animation(.linear(duration: 0.5))
        .padding([.leading, .trailing], 16)
        .padding(.top, 70)
        .background(Color("View"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct Info: View {
            
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                
                Text("(Replace with sign up fields)")
                    .foregroundColor(Color("Label"))
                    .font(Font.custom("Avenir-Black", size: 25))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
        
        .transition(.slideLeading)
        .animation(.linear(duration: 0.5))
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
        .animation(.linear(duration: 0.5))
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
        .animation(.linear(duration: 0.5))
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
        
        Method()
        
        Info()
        
        Verification()
        
        Complete()
    }
}
