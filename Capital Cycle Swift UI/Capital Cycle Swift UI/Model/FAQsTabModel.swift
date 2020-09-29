//
//  FAQsTabModel.swift
//  Capital Cycle Swift UI
//
//  Created by Caden Kowalski on 8/11/20.
//

import Foundation

// MARK: FAQCategory Enum

enum FAQCategory {
    case all
    case schedule
    case payment
    case dropOffPickup
    case biking
}

// MARK: FAQCategorySelector Struct

struct FAQCategorySelector: Identifiable {
    
    var categoryName: String
    var isSelected: Bool
    var category: FAQCategory
    var id: Int
}

// MARK: FAQCell Struct

struct FAQCell: Identifiable {
    
    var question: String
    var answer: String
    var category: FAQCategory
    var id: Int
}

// MARK: FAQsTabModel

struct FAQsTabModel {
    
    var currentCategory: FAQCategory = .all
    var faqCategorySelectors = [
        FAQCategorySelector(categoryName: "All", isSelected: true, category: .all, id: 0),
        FAQCategorySelector(categoryName: "Schedule", isSelected: false, category: .schedule, id: 1),
        FAQCategorySelector(categoryName: "Payment", isSelected: false, category: .payment, id: 2),
        FAQCategorySelector(categoryName: "Drop-off/Pickup", isSelected: false, category: .dropOffPickup, id: 3),
        FAQCategorySelector(categoryName: "Biking", isSelected: false, category: .biking, id: 4)
    ]
    
    let faqCells = [
        FAQCell(question: "When do you usually head out in the morning?", answer: "Around 10:00 - 10:30.", category: .schedule, id: 0),
        FAQCell(question: "When do you usually arrive back at camp?", answer: "Around 3:00 - 4:00.", category: .schedule, id: 1),
        FAQCell(question: "What if it rains?", answer: "We will play it by ear but will err on the side of caution to ensure that campers remain safe.", category: .schedule, id: 2),
        FAQCell(question: "Do you group kids by age or ability?", answer: "Both, it typically depends on the length of the ride. However, the primary determining factor is whether or not the counselors believe that yout camper is ready for a given ride.", category: .biking, id: 3),
        FAQCell(question: "What if my kid is unable to bike back from the destination?", answer: "We generally push campers to make it back on their own but are prepared to call an Uber or Lyft if we beleive that your camper will not be able to make it back themselves.", category: .biking, id: 4),
        FAQCell(question: "Can I get a sibling discout?", answer: "TBD", category: .payment, id: 5),
        FAQCell(question: "What if my child is not a cinfident rider", answer: "We will work with them throughout the week pushing them outside their comfort zone but we can always put them in a less advanced group that will go a shorter distance", category: .biking, id: 6),
        FAQCell(question: "What if I need to pick up my child early one day?", answer: "Contact Curtis at (410) 428-0726 and we will make sure to have your camper back in time.", category: .dropOffPickup, id: 7),
        FAQCell(question: "What if my child doesn't have a bike?", answer: "We ask that all campers who attend bike camp, have a bike.", category: .biking, id: 8),
        FAQCell(question: "Can my child arrive and/ or leave camp by themselves or di I need to be present?", answer: "If you give the counselors explicit permission for your camper to arrive and/ or leave camp by themselves, they can do so.", category: .dropOffPickup, id: 9),
        FAQCell(question: "What do you do when not biking?", answer: "We have a variety of games and books as well as a gym and playground to occupy down time", category: .schedule, id: 10)
    ]
    
    // MARK: Functions
    
    // Swithes FAQ categories
    mutating func switchCategories(from categorySelector: FAQCategorySelector) {
        let currentCategorySelectorIndex = indexWhereSelectedIsTrue()
        let newCategorySelectorIndex = index(of: categorySelector)
        faqCategorySelectors[currentCategorySelectorIndex].isSelected = false
        faqCategorySelectors[newCategorySelectorIndex].isSelected = true
        currentCategory = categorySelector.category
    }
    
    // Returns the index of the requested FAQCategorySelector in faqCategorySelectors
    func index(of categorySelector: FAQCategorySelector) -> Int {
        for index in 0 ..< faqCategorySelectors.count {
            if faqCategorySelectors[index].id == categorySelector.id {
                return index
            }
        }
        
        return 0
    }
    
    // Returns the index of the current FAQCategorySelector in faqCategorySelectors
    func indexWhereSelectedIsTrue() -> Int{
        for index in 0 ..< faqCategorySelectors.count {
            if faqCategorySelectors[index].isSelected == true {
                return index
            }
        }
        
        return 0
    }
}
