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

open class RestFireFileResponse {
    
    fileprivate var request: RestFireRequest!
    fileprivate var progressClosure: ((Float) -> ())?
    
    fileprivate let manager = Alamofire.SessionManager.default
    
    public init(request: RestFireRequest) {
        
        self.request = request
    }
    
    open func progress(_ closure: @escaping (Float) -> ()) -> (RestFireFileResponse) {
        
        self.progressClosure = closure
        
        return self
    }
    
    open func response(_ completion: @escaping (_ filename: String?, _ error: Error?) -> ()) -> Request {
        
        guard let dataRequest = self.request.request as? DownloadRequest else {
            
            return self.request.request
        }
        
        return dataRequest.downloadProgress(closure: {
            progress in
            
            self.progressClosure?(Float(progress.fractionCompleted))
        }).response(completionHandler: {
            data in
            
            if let error = data.error {
                
                return completion(nil, error)
            }
            
            guard let filename = dataRequest.response?.suggestedFilename else {
                
                let error = NSError(domain: "RestFireFileResponse", code: 0, userInfo: ["reason": "No suggedsted filename returned from server."])
                
                return completion(nil, error)
            }
            
            let fileUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
            
            completion(fileUrl.path, nil)
        })
    }
}
