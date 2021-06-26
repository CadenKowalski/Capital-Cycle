//
//  ProductCell.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/8/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productInfo: UILabel!
    
    func updateViews(Product: Product) {
        productImg.image = UIImage(named: Product.imgName)
        productInfo.text = Product.info
    }
}
