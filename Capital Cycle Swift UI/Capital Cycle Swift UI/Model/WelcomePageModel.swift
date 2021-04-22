//
//  WelcomePageModel.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 4/21/21.
//

import Foundation

struct WelcomeCell: Identifiable {
    
    var symbol: String
    var title: String
    var description: String
    var id: Int
}

struct WelcomePageModel {
    
    let welcomeCells: [WelcomeCell] = [
        WelcomeCell(symbol: "person", title: "Create an Account", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam luctus mattis eros in egestas.", id: 1),
        WelcomeCell(symbol: "mappin.and.ellipse", title: "See Couselors' Locaton", description: "Sed facilisis feugiat magna, sed vulputate nunc sollicitudin eu. Fusce ac odio porta, hendrerit urna eget, aliquet augue.", id: 2),
        WelcomeCell(symbol: "calendar", title: "See What's Happening", description: "Maecenas eleifend pellentesque arcu, sit amet luctus tortor laoreet a. Nulla facilisi.", id: 3)
    ]
}
