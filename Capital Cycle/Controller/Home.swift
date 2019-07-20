//
//  Home.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 7/20/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit

class Home: UIViewController {
    
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
    }
    
    func customizeLayout() {
        logInBtn.layer.cornerRadius = 25
        signUpBtn.layer.cornerRadius = 25
    }
}
