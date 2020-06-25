//
//  ViewController.swift
//  ProtocolTest
//
//  Created by Abhishek Chaudhari on 25/06/20.
//  Copyright © 2020 Abhishek Chaudhari. All rights reserved.
//

import UIKit
protocol TestProtocol {
    var testString: String { get }
}

class TestClass1: TestProtocol {
    var testString: String
    init(testString: String) {
        self.testString = testString
    }
}

class TestClass2: TestProtocol {
    var testString: String
    init(testString: String) {
        self.testString = testString
    }
}

class ViewController: UIViewController {

    var testArray: [TestProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let testObj1 = TestClass1(testString: "TestClass1 obj")
        
        let testObj2: TestProtocol = TestClass1(testString: "TestClass1 confirming protocol")
        
        let testObj3: TestClass2 = TestClass2(testString: "TestClass2 confirming protocol")

        testArray.append(testObj1)
        testArray.append(testObj2)
        testType(object: testObj3)

        for obj in testArray {
            print(obj.testString)
        }
    }
    
    func testType<T:TestProtocol>(object: T) {
        testArray.append(object)
    }
}

