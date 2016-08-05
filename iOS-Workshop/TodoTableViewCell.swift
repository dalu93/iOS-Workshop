//
//  TodoTableViewCell.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

final class TodoTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var notesLabel: UILabel!
    @IBOutlet private weak var todoImageView: UIImageView!
    
    func set(with todo: Todo) {
        nameLabel.text = todo.name
        notesLabel.text = todo.notes
        todoImageView.af_setImageWithURL(todo.imgUrl)
    }
}
