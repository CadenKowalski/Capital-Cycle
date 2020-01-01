//
//  CustomButton.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 12/24/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable var gradientColorOne: UIColor = .clear
    @IBInspectable var gradientColorTwo: UIColor = .clear {
        didSet {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [self.gradientColorOne.cgColor, self.gradientColorTwo.cgColor]
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var gradientColorOne: UIColor = .clear
    @IBInspectable var gradientColorTwo: UIColor = .clear {
        didSet {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [self.gradientColorOne.cgColor, self.gradientColorTwo.cgColor]
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.cornerRadius = self.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

@IBDesignable
class CustomLabel: UILabel {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
}

@IBDesignable
class CustomImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
}

@IBDesignable
class CustomTextView: UITextView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
}
