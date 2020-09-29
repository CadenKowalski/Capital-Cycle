//
//  AppleUserNavigationController.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 1/3/20.
//  Copyright © 2020 Caden Kowalski. All rights reserved.
//

import UIKit

class AppleUserNavigationController: UINavigationController {

    // MARK: View Instantiation
    
    // Runs when the view is loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
    }
    
    // Sets the presentation controller
    func setUpNavigationController() {
        self.presentationController?.delegate = self.topViewController as! OneMoreStep
    }
}
