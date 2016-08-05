//
//  Dynamic.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

final class Dynamic<T> {
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    private var listener: ((T) -> ())?
    
    func bind(listener: ((T) -> ())) {
        self.listener = listener
    }
    
    func bindAndFire(listener: ((T) -> ())) {
        self.listener = listener
        listener(value)
    }
}