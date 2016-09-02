//
//  RestFireRequest.swift
//  RestFire
//
//  Copyright © 2016 Olaf Andreas Øvrum.
//
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//  to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of
//  the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
//  THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import Foundation
import Alamofire
import SwiftyJSON

public class RestFireRequest {
    
    var request: Request!
    
    private var url: String!
    static var token: String!
    
    private var headers: [String: String] {
        return ["Authorization": "\(RestFireRequest.token)",
                "Accept": "/json",
                "Content-Type": "/json"]
    }
    
    public init(url: String!, token: String!) {
        
        self.url = url
        
        RestFireRequest.token = token
    }
    
    public subscript(path: AnyObject) -> RestFireRequest {
        
        guard path is String || path is Int else {
            
            fatalError("Path must be of type Int or String")
        }
        
        url.appendContentsOf("/\(path)")
        
        return self
    }
    
    /// Create
    public func post(parameters: [String: AnyObject]? = nil) -> RestFireResponse {
        
        self.request = request(.POST, parameters: parameters, encoding: .JSON)
        
        return RestFireResponse(request: request)
    }
    
    /// Read
    public func get(parameters: [String: AnyObject]? = nil) -> RestFireResponse {
        
        self.request = request(.GET, parameters: parameters, encoding: .URLEncodedInURL)
        
        return RestFireResponse(request: request)
    }
    
    /// Create/Update
    public func put(parameters: [String: AnyObject]) -> RestFireResponse {
        
        self.request = request(.PUT, parameters: parameters, encoding: .JSON)
        
        return RestFireResponse(request: request)
    }
    
    /// Update
    public func patch(parameters: [String: AnyObject]) -> RestFireResponse {
        
        self.request = request(.PATCH, parameters: parameters, encoding: .JSON)
        
        return RestFireResponse(request: request)
    }
    
    /// Delete
    public func delete() -> RestFireResponse {
        
        self.request = request(.DELETE, parameters: nil, encoding: .JSON)
        
        return RestFireResponse(request: request)
    }
    
    /// Download
    public func download(parameters: [String: AnyObject]? = nil, destination: String? = nil) -> RestFireFileResponse {
        
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        urlRequest.HTTPMethod = "POST"
        urlRequest.allHTTPHeaderFields = self.headers
        
        let downloadRequest = Alamofire.ParameterEncoding.JSON.encode(urlRequest, parameters: parameters).0
        
        self.request = Alamofire.download(downloadRequest, destination: {
            (tempUrl, response) in
            
            // Try to get the url for the Documents directory for this application
            let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            
            // Get the suggested filename from the download response
            let pathComponent = response.suggestedFilename!
            
            var fileUrl = directoryURL.URLByAppendingPathComponent(pathComponent)
            
            // Check if another directory is defined
            if let destination = destination, url = NSURL(string: destination) {
                
                fileUrl = url.URLByAppendingPathComponent(pathComponent)
            }
            
            // Append the suggested filename to the directory url
            return fileUrl
        })
        
        return RestFireFileResponse(request: self)
    }
    
    private func request(method: Alamofire.Method, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding) -> Request {
        
        return Alamofire.request(method, self.url, parameters: parameters, encoding: encoding, headers: headers)
    }
}