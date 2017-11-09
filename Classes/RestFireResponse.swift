//
//  RestFireResponse.swift
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
import SwiftyJSON
import Alamofire

open class RestFireResponse {
    
    fileprivate var request: Request!
    
    public init(request: Request) {
        
        self.request = request
    }
    
    open func response(_ completion: @escaping (JSON?, Int, Error?) -> ()) -> Request {
        
        guard let dataRequest = self.request as? DataRequest else {
        
            return self.request
        }
        
        return dataRequest.responseJSON(completionHandler: {
            response in
            
            if let error = response.result.error {
                
                return completion(nil, response.response?.statusCode ?? 0, error)
            }
            
            guard let data = response.data else {
                
                return completion(nil, response.response?.statusCode ?? 0, NSError(domain: "RestFire", code: 0, userInfo: ["reason": "No data returned from server."]))
            }
            
            do {
                
                let json = try JSON(data: data)
                
                
                if let error = json.error {
                
                    return completion(nil, response.response?.statusCode ?? 0, error)
                }
                
                if let array = json.array, array.count == 1 {
                
                    return completion(json.first?.1, response.response?.statusCode ?? 0, nil)
                }
                
                completion(json, response.response?.statusCode ?? 0, nil)
            }
            catch {
                
                completion(nil, response.response?.statusCode ?? 0, error)
            }
        })
    }
}
