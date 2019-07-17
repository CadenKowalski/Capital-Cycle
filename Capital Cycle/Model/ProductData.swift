//
//  ProductData.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/8/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import Foundation

class ProductData {
    static let Instance = ProductData()
    private let campProducts = [
        Product(Info: "Session 1 (4 days)\n$375", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Session 2 (5 days)\n$430", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Session 3 (4 days)\n$375", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Session 4 (5 days)\n$430", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Session 5 (5 days)\n$430", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Session 6 (5 days)\n$430", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Before care\n$10 per day", ImgName: "CapitalCycleStoreLogo"),
        Product(Info: "Camp T-shirt\n$20", ImgName: "ShirtImg")]
    
    func getProducts() -> [Product] {
        return campProducts
    }
}
