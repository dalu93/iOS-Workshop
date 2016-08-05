//
//  APIController.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation
import Alamofire

enum Completion<Value, Error> {
    
    case Success(Value)
    case Failed(Error)
}

typealias JSONDictionary = [String : AnyObject]

final class APIController {
    
    func load(endpoint endpoint: Endpoint, completion: Completion<JSONDictionary, NSError> -> ()) -> Alamofire.Request? {
        
        return Alamofire.request(
            endpoint.alamofireMethod,
            endpoint.completePath,
            parameters: endpoint.paramters,
            encoding: .URL,
            headers: endpoint.headers
            ).validate()
            .responseJSON(completionHandler: { response in
                
                switch response.result {
                case .Success(let jsonObject):
                    guard let json = jsonObject as? JSONDictionary else {
                        completion(.Failed(.NotValidJSON))
                        return
                    }
                    
                    completion(.Success(json))
                    
                case .Failure(let error):
                    completion(.Failed(error))
                }
            })
    }
}

private extension Endpoint {
    var completePath: String {
        return Constants.API.baseURL + self.path
    }
    
    var alamofireMethod: Alamofire.Method {
        return Alamofire.Method(rawValue: self.httpMethod.rawValue)!
    }
}

private extension NSError {
    static var NotValidJSON: NSError {
        return NSError(
            domain: "APIController",
            code: -1,
            userInfo: [
                NSLocalizedDescriptionKey : "Not a valid JSON"
            ]
        )
    }
}