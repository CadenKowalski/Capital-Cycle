//
//  SettingsCellView.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 4/10/21.
//

import SwiftUI

// MARK: SettingsCellView View

struct SettingsCellView: View {
    
    var settingName: String
    @Binding var toggleValue: Bool
    
    var body: some View {
            
        ZStack {
        
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 45)
                .foregroundColor(Color("TextFieldColor"))
                .padding([.leading, .trailing], 16)
            
            Toggle(isOn: $toggleValue) {
                
                Text(settingName)
                    .font(Font.custom("Avenir-Medium", size: 18))
                    .foregroundColor(Color("LabelColor"))
            }
            
            .padding([.leading, .trailing], 32)
            .toggleStyle(SwitchToggleStyle(tint: Color("LabelColor")))
        }
    }
}
