//
//  FAQsTab.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI
import MessageUI

// MARK: FAQsTab Tab

struct FAQsTab: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var user: User
    @State var didRequestToSendEmail = false
    @State var didConfirmIntentToSendEmail = false
    
    // MARK: View Construction
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                
                GradientView(title: "FAQs", viewIsInSheet: false, viewIsInControlPage: true)
                    .environmentObject(viewModel)
                    .environmentObject(user)
                
                ScrollView {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                    
                        HStack {
                            
                            ForEach(viewModel.faqCategorySelectors) { faqCategorySelector in
                                FAQCategoryView(categoryName: faqCategorySelector.categoryName, isSelected: faqCategorySelector.isSelected)
                                    .onTapGesture {
                                        viewModel.switchFAQCategories(from: faqCategorySelector)
                                    }
                            }
                        }
                        
                        .padding([.leading, .trailing, .top], 16)
                        .padding(.bottom, 8)
                    }
                    
                    ForEach(viewModel.faqCells) { faqCell in
                        
                        if faqCell.category == viewModel.currentCategory || viewModel.currentCategory == .all {
                            FAQCellView(question: faqCell.question, answer: faqCell.answer)
                        }
                    }
                    
                    .padding( .bottom, 2)
                    .frame(width: UIScreen.main.bounds.width)
                }
                
                .padding(.bottom, 8)
                .background(Color("View"))
            }
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        didRequestToSendEmail = true
                    }) {
                        Image(systemName: "questionmark").resizable()
                            .font(Font.title.weight(.semibold))
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                            .foregroundColor(.white)
                    }
                    
                    .frame(width: 50, height: 50)
                    .background(Gradients.titleGradient)
                    .cornerRadius(25)
                
                    .actionSheet(isPresented: $didRequestToSendEmail) {
                        ActionSheet(title: Text("Have a question?"), message: Text("Feel free to send us an email and we will get back to you as soon as possible"), buttons: [
                            .default(Text("Ask a Question")) {
                                didConfirmIntentToSendEmail = true
                            },
                            .cancel()
                        ])
                    }
                
                    .sheet(isPresented: $didConfirmIntentToSendEmail) {
                        MailView(recipient: "capitalcyclecamp@gmail.com", subject: "Question", messageBody: "<p>Capital Cycle Team, </p>")
                    }
                }
                
                .padding(.bottom, 16)
            }
            
            .padding(.trailing, 16)
        }
        
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Preview

// Initializes the preview
struct FAQsTab_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            FAQsTab().environmentObject(ViewModel())
                .previewDevice("iPod touch (7th generation)")
            
            FAQsTab().environmentObject(ViewModel())
                .previewDevice("iPhone 8")
            
            FAQsTab().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro")
            
            FAQsTab().environmentObject(ViewModel())
                .previewDevice("iPhone 11 Pro Max")
        }
        
        .environment(\.colorScheme, .dark)
    }
}
