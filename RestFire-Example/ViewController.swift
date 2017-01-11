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
        
        _ = rest["comments"].post(["title": "Foo", "Author": "Mr. Bar"]).response {
            value, _, error in
            
            print(value ?? "no value")
            print(error ?? "no error")
        }
    }
}
