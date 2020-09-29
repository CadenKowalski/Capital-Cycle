//
//  RegisterTabModel.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/11/20.
//

import Foundation

// MARK: RegisterCell Struct

struct RegisterCell: Identifiable {
    
    var image: String = "SessionImage"
    var product: String
    var price: String
    var URL: URL
    var id: Int
}

// MARK: RegisterTabModel

struct RegisterTabModel {
    
    let registerCells = [
        RegisterCell(product: "Session 1 (4 days)", price: "from $375", URL: URL(string: "https://capitalcyclecamp.org/pay-for-camp/5-day-session-1-6216")!, id: 0),
        RegisterCell(product: "Session 2 (5 days)", price: "from $430", URL: URL(string: "https://capitalcyclecamp.org/pay-for-camp/1-5-day-session-of-cycle-camp-spring-break-and-summer-session-1245")!, id: 1),
        RegisterCell(product: "Session 3 (4 days)", price: "from $375", URL: URL(string: "https://capitalcyclecamp.org/pay-for-camp/4-day-session-of-cycle-camp")!, id: 2),
        RegisterCell(product: "Session 4 (5 days)", price: "from $430", URL: URL(string: "https://capitalcyclecamp.org/pay-for-camp/session-4-5-day-71116")!, id: 3),
        RegisterCell(product: "Session 5 (5 days)", price: "from $430", URL: URL(string: "https://capitalcyclecamp.org/pay-for-camp/5-day-session-5-71816")!, id: 4),
        RegisterCell(product: "Session 6 (5 days)", price: "from $430", URL: URL(string: "https://capitalcyclecamp.org/pay-for-camp/5-day-session-5-71816-7rnnm")!, id: 5),
        RegisterCell(product: "Before Care", price: "$10 per day", URL: URL(string: "https://capitalcyclecamp.org")!, id: 6),
        RegisterCell(image: "ShirtImage", product: "Camp T-Shirt", price: "$20", URL: URL(string: "https://capitalcyclecamp.org/pay-for-camp/bike-camp-t-shirt")!, id: 7),
    ]
}
