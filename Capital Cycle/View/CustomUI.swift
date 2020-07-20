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
    
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable var gradient: Bool = false {
        didSet {
            if gradient == true {
                gradientLayer.frame = self.bounds
                gradientLayer.colors = [UIColor(named: "gradientOrange")!.cgColor, UIColor(named: "gradientPurple")!.cgColor]
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.cornerRadius = self.cornerRadius
                layer.insertSublayer(gradientLayer, at: 0)
            } else {
                gradientLayer.removeFromSuperlayer()
            }
        }
    }
    
    @IBInspectable var cellGradient: Bool = false {
        didSet {
            if cellGradient == true {
                gradientLayer.frame = self.bounds
                gradientLayer.colors = [UIColor(named: "DarkPurple")!.cgColor, UIColor(named: "LightPurple")!.cgColor]
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.cornerRadius = self.cornerRadius
                layer.insertSublayer(gradientLayer, at: 0)
            } else {
                gradientLayer.removeFromSuperlayer()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
}

@IBDesignable
class CustomButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable var gradient: Bool = false {
        didSet {
            if gradient == true {
                gradientLayer.frame = self.bounds
                gradientLayer.colors = [UIColor(named: "gradientOrange")!.cgColor, UIColor(named: "gradientPurple")!.cgColor]
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.cornerRadius = self.cornerRadius
                layer.insertSublayer(gradientLayer, at: 0)
            } else {
                gradientLayer.removeFromSuperlayer()
            }
        }
    }
    
    @IBInspectable var cellGradient: Bool = false {
        didSet {
            if cellGradient == true {
                gradientLayer.frame = self.bounds
                gradientLayer.colors = [UIColor(named: "DarkPurple")!.cgColor, UIColor(named: "LightPurple")!.cgColor]
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.cornerRadius = self.cornerRadius
                layer.insertSublayer(gradientLayer, at: 0)
            } else {
                gradientLayer.removeFromSuperlayer()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable var borderRadius: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
}

@IBDesignable
class CustomLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var interactionEnabled: Bool = false {
        didSet {
            self.isUserInteractionEnabled = interactionEnabled
        }
    }
}

@IBDesignable
class CustomImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}

@IBDesignable
class CustomTextView: UITextView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
