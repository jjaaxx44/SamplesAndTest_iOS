//
//  ViewController.swift
//  SSLPinningTest
//
//  Created by Abhishek Chaudhari on 06/02/20.
//  Copyright © 2020 Abhishek Chaudhari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkManager.networkManager.certificatePinningTest()
//        NetworkManager.networkManager.publicKeyPinningTest()
    }
}

