//
//  Product.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/8/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import Foundation

struct Product {
    private(set) public var Info: String
    private(set) public var ImgName: String
    
    init(Info: String, ImgName: String) {
        self.Info = Info
        self.ImgName = ImgName
    }
}
