//
//  ViewController.swift
//  RestFire-Example
//
//  Created by Olaf Øvrum on 29.06.2016.
//  Copyright © 2016 Hucon Global AS. All rights reserved.
//

import UIKit
import RestFire

class ViewController: UIViewController {

    let rest = RestFire(baseUrl: "http://jsonplaceholder.typicode.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rest["comments"].post(["title": "Foo", "Author": "Mr. Bar"]).response {
            value, error in
            
            print(error)
            
            print(value)
        }
    }
}