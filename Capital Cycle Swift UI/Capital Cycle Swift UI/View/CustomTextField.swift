//
//  CustomTextField.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/10/20.
//

import SwiftUI

// MARK: CustomTextField View

struct CustomTextField: View {
    
    var placeholderString: String
    @Binding var text: String

    // MARK: View Construction
    
    var body: some View {
                    
        TextField("\(placeholderString)", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(Font.custom("Avenir-Book", size: 13))
    }
}
