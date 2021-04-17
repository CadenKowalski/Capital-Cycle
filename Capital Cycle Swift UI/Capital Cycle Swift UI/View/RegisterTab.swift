//
//  RegisterTab.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: RegisterTab Tab

struct RegisterTab: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var user: User
    
    // MARK: View Construction
    
    var body: some View {
        
        VStack {
            
            GradientView(title: "Register", viewIsInSheet: false, viewIsInControlPage: true)
                .environmentObject(viewModel)
                .environmentObject(user)
            
            ScrollView {
                
                ForEach(0 ..< 4) { index in
                        
                    HStack {
                        
                        let firstCell = viewModel.registerCells[index * 2]
                        RegisterCellView(image: firstCell.image, product: firstCell.product, price: firstCell.price)
                        let secondCell = viewModel.registerCells[index * 2 + 1]
                        RegisterCellView(image: secondCell.image, product: secondCell.product, price: secondCell.price)
                    }
                    
                    .padding([.leading, .trailing], 8)
                }
            }
            
            .padding(.bottom, 8)
        }
        
        .background(Color("ViewColor"))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Preview

// Initializes the preview
struct RegisterTab_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            RegisterTab().environmentObject(ViewModel())
                .previewDevice("iPod touch (7th generation)")
            
            RegisterTab().environmentObject(ViewModel())
                .previewDevice("iPhone 8")
            
            RegisterTab().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro")
            
            RegisterTab().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro Max")
        }
        
        .environment(\.colorScheme, .dark)
    }
}
