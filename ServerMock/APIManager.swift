//
//  APIManager.swift
//  ServerMock
//
//  Created by Sergey Pogrebnyak on 11.11.2019.
//  Copyright © 2019 Sergey Pogrebnyak. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

enum LoginLinks: String, CaseIterable {
    case login
    case errorLogin
    case wrong
}

class APIManager: NSObject, URLSessionDelegate {
    static var shared = APIManager()

    private let baseURL = "https://91e087ee-781f-45cc-94c9-3a4f8739bb1f.mock.pstmn.io/"

    private enum Method: String {
        case post, get
    }

    func login(loginLinks: LoginLinks, callback: @escaping (User?, NSError?) -> Void) {
        sendRequest(url: baseURL + loginLinks.rawValue) { (optionalJson) in
            guard let json = optionalJson else {
                callback(nil, self.createErrorWithText())
                return
            }
            
            if json["status"].boolValue {
                callback(User(fromJson: json), nil)
            } else {
                callback(nil, self.createErrorWithText(json["error"].string))
            }
        }
    }

    private var urlSession: URLSession {
        get {
            let configuration = URLSessionConfiguration.default
            configuration.urlCache = nil
            return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        }
    }

    private func sendRequest(url: String,
                             method: Method = .post,
                             jsonParams: [String : Any]? = nil,
                             callback: @escaping ((JSON?) -> ())) {
        do {
            let url = URL(string: url)!
            var request = URLRequest(url: url)
            let session = APIManager.shared.urlSession
            request.httpMethod = method.rawValue

            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            if let jsonParams = jsonParams {
                request.httpBody = try JSONSerialization.data(withJSONObject: jsonParams, options: .prettyPrinted)
            }

            let task = session.dataTask(with: request, completionHandler: {(optionalData, optionalResponse, error) in
                session.finishTasksAndInvalidate()
                guard   let data:Data = optionalData,
                        let response:HTTPURLResponse = optionalResponse as? HTTPURLResponse,
                        error == nil else {
                    print("error: \(error?.localizedDescription ?? "Unknown")" )
                    callback(nil)
                    return
                }
                DispatchQueue.main.async {
                    guard let jsonObject = try? JSON(data: data), response.statusCode == 200 else {
                        callback(nil)
                        return
                    }
                    callback(jsonObject)
                }
            })
            task.resume()
        } catch {}
    }

    private func createErrorWithText(_ text: String? = nil) -> NSError {
        let textDescription = text != nil ? text : "Another error, please try again."
        return NSError.init(domain: "Error authorization", code: 400, userInfo: ["error": textDescription as Any])
    }
}
