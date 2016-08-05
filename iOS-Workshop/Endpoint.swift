//
//  Endpoint.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

struct Endpoint {
    
    let path: String
    let httpMethod: HTTPMethod
    let headers: [String : String]?
    let paramters: [String : AnyObject]?
}