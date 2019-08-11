//
//  Gradient.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 5/26/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setTwoGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [#colorLiteral(red: 0.9176470588, green: 0.5882352941, blue: 0.3607843137, alpha: 1).cgColor, #colorLiteral(red: 0.7882352941, green: 0.3725490196, blue: 0.8470588235, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setTwoGradientButton(cornerRadius: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [#colorLiteral(red: 0.9176470588, green: 0.5882352941, blue: 0.3607843137, alpha: 1).cgColor, #colorLiteral(red: 0.7882352941, green: 0.3725490196, blue: 0.8470588235, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.cornerRadius = cornerRadius
        layer.insertSublayer(gradientLayer, at: 1)
    }
}
