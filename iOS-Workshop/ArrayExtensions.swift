//
//  ArrayExtensions.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation

extension Array {
    func get(at index: Int) -> Element? {
        if index >= self.count || index < 0 { return nil }
        return self[index]
    }
}