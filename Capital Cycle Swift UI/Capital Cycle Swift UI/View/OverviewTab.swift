//
//  OverviewTab.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: OverviewTab Tab

struct OverviewTab: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            GradientView(title: "Overview", viewIsInSheet: false, viewIsInControlPage: true)
            
            ScrollView {
                
                VStack(spacing: 10) {
                    
                    ForEach(viewModel.overviewCells) { overviewCell in
                        
                        OverviewCellView(title: overviewCell.title, text: overviewCell.text)
                            .onTapGesture(count: 1) {
                                if overviewCell.title == "Camp Location:" {
                                    viewModel.redirectToCampLocation()
                                }
                            }
                    }
                    
                    HStack {
                        
                        Image("FacebookLogo").resizable()
                            .frame(width: 50, height: 50)
                            .padding(.leading, 90)
                            .onTapGesture(count: 1) {
                                viewModel.redirectToFacebook()
                            }
                        
                        Spacer()
                        
                        Image("InstagramLogo").resizable()
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 90)
                            .onTapGesture(count: 1) {
                                viewModel.redirectToInstagram()
                            }
                    }
                
                    .padding(.all, 8)
                }
                
                .padding(.top, 8)
            }
            
            .frame(width: UIScreen.main.bounds.width)
            .background(Color("ViewColor"))
        }
        
        .background(Color("ViewColor"))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Preview

// Initializes the preview
struct OverviewTab_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            OverviewTab().environmentObject(ViewModel())
                .previewDevice("iPod touch (7th generation)")
            
            OverviewTab().environmentObject(ViewModel())
                .previewDevice("iPhone 8")
            
            OverviewTab().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro")
            
            OverviewTab().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro Max")
        }
        
        .environment(\.colorScheme, .dark)
    }
}
