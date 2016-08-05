//
//  ReusableView.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView {
    static var identifier: String { get }
    static var nibName: String { get }
}

extension ReusableView where Self: UITableViewCell {
    static var identifier: String { return String(Self) }
    static var nibName: String { return String(Self) }
}