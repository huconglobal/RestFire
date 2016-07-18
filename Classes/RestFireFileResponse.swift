//
//  RestFireFileRequest.swift
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

public class RestFireFileResponse {
    
    private var request: RestFireRequest!
    private var progressClosure: ((Float) -> ())?
    
    private let manager = Alamofire.Manager()
    
    public init(request: RestFireRequest) {
        
        self.request = request
    }
    
    public func progress(closure: (Float) -> ()) -> (RestFireFileResponse) {
        
        self.progressClosure = closure
        
        return self
    }
    
    public func response(completion: (filename: String?, error: NSError?) -> ()) -> Request {
        
        return self.request.request
            .progress {
                (_, totalBytesRead, totalBytesExpectedToRead) in
                
                self.progressClosure?((Float(totalBytesRead) / Float(totalBytesExpectedToRead)))
            }
            .response {
                (urlRequest, response, data, error) in
                
                if let error = error {
                    
                    return completion(filename: nil, error: error)
                }
                
                guard let filename = response?.suggestedFilename else {
                    
                    let restError = NSError(domain: "RestFire", code: 0, userInfo: ["Reason": "No suggested filename available in download response."])
                    
                    return completion(filename: nil, error: restError)
                }
                
                completion(filename: filename, error: nil)
        }
    }
}