//
//  GradientView.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: GradientView View

struct GradientView: View {
    
    var title: String
    var viewIsInSheet: Bool
    var viewIsInControlPage: Bool
    var deviceHasNotch = UIScreen.main.bounds.height > 700
    @State var didTapOnGeneralSettings = false
    @State var didTapOnAccountSettings = false
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var user: User
    
    // MARK: View Construction
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            let titleString = Text(title)
                .fontWeight(.bold)
            
            if viewIsInSheet {
                
                titleString
                    .font(.custom("Avenir-Medium", size: 40))
            } else if deviceHasNotch {
                
                titleString
                    .padding(.top, 25)
            } else {
                
                titleString
                    .padding(.top, 10)
            }
            
            if viewIsInControlPage {
                
                HStack() {
                    
                    Button(action: {
                        
                        didTapOnGeneralSettings = true
                    }) {
                        
                        Image(systemName: "gear").resizable()
                            .frame(width: UIScreen.main.bounds.width / 10.71, height: UIScreen.main.bounds.width / 10.71)
                            .padding(.leading, 20)
                    }
                    
                    .sheet(isPresented: $didTapOnGeneralSettings) {
                        
                        GeneralSettings()
                            .environmentObject(viewModel)
                            .environmentObject(user)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                        didTapOnAccountSettings = true
                    }) {
                        
                        Image(systemName: "person.circle").resizable()
                            .frame(width: UIScreen.main.bounds.width / 10.71, height: UIScreen.main.bounds.width / 10.71)
                            .padding(.trailing, 20)
                    }
                    
                    .sheet(isPresented: $didTapOnAccountSettings, content: {
                        
                        AccountSettings(isPresented: $didTapOnAccountSettings)
                            .environmentObject(viewModel)
                            .environmentObject(user)
                    })
                }
            }
        }
        
        .foregroundColor(.white)
        .font(.system(size: 30))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 8.12, alignment: .center)
        .background(Gradients.titleGradient)
    }
}

// MARK: Preview

// Initializes the preview
struct GradientView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            GradientView(title: "Overview", viewIsInSheet: true, viewIsInControlPage: false)
            
            GradientView(title: "Overview", viewIsInSheet: false, viewIsInControlPage: true)
        }
        
        .previewLayout(.fixed(width: 375, height: 100))
    }
}
