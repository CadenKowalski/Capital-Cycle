//
//  Welcome.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 4/21/21.
//

import SwiftUI

struct Welcome: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var user: User
    @State var alreadyHasAccount = false
    @State var didContinue = false
    @State var progressBarValue: Double
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                    
                ZStack(alignment: .leading) {
                                    
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 15)
                        .foregroundColor(.gray)
                        .opacity(0.3)
                        .cornerRadius(10)
                    
                    Rectangle()
                        .frame(maxWidth: CGFloat((Double(geometry.size.width) - 32) * Double(progressBarValue)), maxHeight: 15)
                        .foregroundColor(.clear)
                        .background(Gradients.titleGradient)
                        .cornerRadius(10)
                        .animation(.linear(duration: 0.5))
                }
                    
                
                .padding(.top, 50)
                .padding([.leading, .trailing], 16)
                
                switch progressBarValue {
                
                    case 0:
                        
                        Intro()
                        
                    case 0.2:
                        
                        Who()
                        
                    case 0.4:
                        
                        Method()
                        
                    case 0.6:
                        
                        Info()
                        
                    case 0.8:
                        
                        Verification()
                        
                    case 1.0:
                        
                        Complete()
                        
                    default:
                        
                        Info()
                }
                
                Spacer()
                
                Button(action: {
                    
                    UserDefaults.standard.setValue(true, forKey: "userHasContinuedThroughWelcomePage")
                    if progressBarValue == 1 {
                        
                        didContinue = true
                    } else {
                        
                        progressBarValue += 0.2
                    }
                }) {
                    Text("Continue")
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 45)
                        .background(Gradients.titleGradient)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(Font.custom("Avenir-medium", size: 17))
                }
                
                .shadow(color: Color("MidGradient"), radius: 100)
                .padding([.leading, .trailing], 24)
                .padding(.bottom, 8)
                
                Button(action: {
                    
                    alreadyHasAccount = true
                }) {
                    
                    Text("I already have an account")
                        .foregroundColor(.white)
                        .font(Font.custom("Avenir-Medium", size: 17))
                }
                
                .padding([.leading, .trailing], 24)
                .padding(.bottom, 40)
            }
            
            .fullScreenCover(isPresented: $alreadyHasAccount) {
                                
                    Login()
                        .environmentObject(viewModel)
                        .environmentObject(user)
            }
            
            .fullScreenCover(isPresented: $didContinue) {
                                
                    TabController()
                        .environmentObject(viewModel)
                        .environmentObject(user)
            }

            
            .background(Color("View"))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Welcome_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Welcome(progressBarValue: 0.6)
            .preferredColorScheme(.dark)
            .environmentObject(ViewModel())
            .environmentObject(User())
    }
}
