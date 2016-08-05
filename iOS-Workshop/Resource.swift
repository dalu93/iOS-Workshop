//
//  Resource.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

struct Resource<A> {
    let endpoint: Endpoint
    let parseJSON: JSONDictionary -> A?
}