//
//  PageFour.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/9/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

class PageFour: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    func customizeLayout() {
        gradientView.setTwoGradientBackground(colorOne: Colors.Orange, colorTwo: Colors.Purple)
    }
}
