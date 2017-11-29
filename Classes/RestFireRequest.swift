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

open class RestFireRequest {

    var request: Request!

    open var url: String!
    static var token: String!

    fileprivate var headers: [String: String] {
        return ["Authorization": RestFireRequest.token,
                "Accept": "/json",
                "Content-Type": "/json"]
    }

    public init(url: String!, token: String!) {

        self.url = url

        RestFireRequest.token = token
    }

    open subscript(path: AnyHashable) -> RestFireRequest {

        guard path is String || path is Int else {

            fatalError("Path must be of type Int or String")
        }

        url.append("/\(path)")

        return self
    }

    /// Create
    open func post(_ parameters: Parameters? = nil) -> RestFireResponse {

        self.request = request(.post, parameters: parameters, encoding: JSONEncoding.default)

        return RestFireResponse(request: request)
    }

    /// Read
    open func get(_ parameters: Parameters? = nil) -> RestFireResponse {

        self.request = request(.get, parameters: parameters, encoding: URLEncoding.httpBody)

        return RestFireResponse(request: request)
    }

    /// Create/Update
    open func put(_ parameters: Parameters) -> RestFireResponse {

        self.request = request(.put, parameters: parameters, encoding: JSONEncoding.default)

        return RestFireResponse(request: request)
    }

    /// Update
    open func patch(_ parameters: Parameters) -> RestFireResponse {

        self.request = request(.patch, parameters: parameters, encoding: JSONEncoding.default)

        return RestFireResponse(request: request)
    }

    /// Delete
    open func delete() -> RestFireResponse {

        self.request = request(.delete, parameters: nil, encoding: JSONEncoding.default)

        return RestFireResponse(request: request)
    }

    /// Download
    open func download(_ parameters: Parameters? = nil, destination: String? = nil) -> RestFireFileResponse {

        var r = URLRequest(url: URL(string: url)!)
        r.httpMethod = "POST"
        r.allHTTPHeaderFields = self.headers

        let downloadRequest: URLRequestConvertible = try! JSONEncoding().encode(r, with: parameters)

        self.request = Alamofire.download(downloadRequest, to: {
            (tempUrl, response) in

            // Try to get the url for the Documents directory for this application
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

            var fileUrl = directoryURL

            // Check if another destination is defined
            if let destination = destination {

                fileUrl = URL(fileURLWithPath: destination)

            } else if let suggestedFilename = response.suggestedFilename {

                fileUrl.appendPathComponent(suggestedFilename)
            } else {

                fileUrl.appendPathComponent("update.zip")
            }

            return (fileUrl, DownloadRequest.DownloadOptions.removePreviousFile)
        })

        return RestFireFileResponse(request: self)
    }

    open func request(_ method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding) -> Request {

        return Alamofire.request(self.url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}
