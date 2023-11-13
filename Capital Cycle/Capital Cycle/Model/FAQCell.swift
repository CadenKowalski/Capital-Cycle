//
//  FAQ.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/21/20.
//  Copyright © 2020 Caden Kowalski. All rights reserved.
//

import Foundation

struct FAQCell {
    
    enum Category {
        case all
        case schedule
        case payment
        case dropOffPickup
        case biking
    }
    
    var question: String
    var answer: String
    var category: Category
    
    init(Question: String, Answer: String, Category: Category) {
        self.question = Question
        self.answer = Answer
        self.category = Category
    }
}
