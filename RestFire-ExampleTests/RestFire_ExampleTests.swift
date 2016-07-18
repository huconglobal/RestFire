//
//  RestFire_ExampleTests.swift
//  RestFire-ExampleTests
//
//  Created by Olaf Øvrum on 29.06.2016.
//  Copyright © 2016 Hucon Global AS. All rights reserved.
//

import XCTest
@testable import RestFire

class RestFire_ExampleTests: XCTestCase {
    
    let rest = RestFire(baseUrl: "http://jsonplaceholder.typicode.com")
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPost(){
        
        let expectation = expectationWithDescription("Async post")
        
        rest["comments"].post(["title": "Foo", "Author": "Mr. Bar"]).response {
            value, error in
            
            expectation.fulfill()
            
            XCTAssertNil(error)
            
            XCTAssertNotNil(value)
        }
        
        expect()
    }
    
    func testGetSingle(){
        
        let expectation = expectationWithDescription("Async get")
        
        let postId = 1
        
        rest["posts"].get(["id": postId]).response {
            value, error in
            
            expectation.fulfill()
            
            XCTAssertNil(error)
            
            XCTAssertNotNil(value)
            
            guard let value = value, id = value["id"].int else {
                
                return XCTFail("Invalid json response")
            }
            
            XCTAssertEqual(id, postId)
        }
        
        expect()
    }
    
    func testGetAll(){
        
        let expectation = expectationWithDescription("Async get")
        
        rest["posts"].get().response {
            value, error in
            
            expectation.fulfill()
            
            XCTAssertNil(error)
            
            XCTAssertNotNil(value)
            
            guard let value = value else {
                
                return XCTFail("Invalid json response")
            }
            
            XCTAssertEqual(value.count, 100)
        }
        
        expect()
    }
    
    func testGetCommentsForPost(){
        
        let expectation = expectationWithDescription("Async get")
        
        rest["posts"][1]["comments"].get().response {
            value, error in
            
            expectation.fulfill()
            
            XCTAssertNil(error)
            
            guard let value = value else {
                
                return XCTFail("Invalid json response")
            }
            
            XCTAssertEqual(value.count, 5)
        }
        
        expect()
    }
    
    func testPut(){
        
        let expectation = expectationWithDescription("Async get")
        
        let postId = 1
        
        rest["posts"][postId].put(["title": "Some new title"]).response {
            value, error in
            
            expectation.fulfill()
            
            XCTAssertNil(error)
            
            XCTAssertNotNil(value)
            
            guard let value = value, id = value["id"].int else {
                
                return XCTFail("Invalid json response")
            }
            
            XCTAssertEqual(id, postId)
        }
        
        expect()
    }
    
    func testPatch(){
        
        let expectation = expectationWithDescription("Async get")
        
        let postId = 1
        
        rest["posts"][postId].patch(["title": "Some Title"]).response {
            value, error in
            
            expectation.fulfill()
            
            XCTAssertNil(error)
            
            XCTAssertNotNil(value)
            
            guard let value = value, id = value["id"].int else {
                
                return XCTFail("Invalid json response")
            }
            
            XCTAssertEqual(id, postId)
        }
        
        expect()
    }
    
    func testDelete(){
        
        let expectation = expectationWithDescription("Async get")
        
        let postId = 1
        
        rest["posts"][postId].delete().response {
            value, error in
            
            expectation.fulfill()
            
            XCTAssertNil(error)
            
            XCTAssertNotNil(value)
        }
        
        expect()
    }
    
    func expect() {
        
        waitForExpectationsWithTimeout(3) {
            error in
            
            if let error = error {
                
                print("Error: \(error)")
            }
        }
    }
}
