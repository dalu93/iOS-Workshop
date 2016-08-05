//
//  TodoDetailViewController.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import UIKit

final class TodoDetailViewController: UIViewController {
    var todoId: String?
    
    private lazy var indicator: UIActivityIndicatorView = self._indicator()
    
    private var viewModel: TodoDetailViewModel! {
        didSet {
            viewModel.status.bindAndFire { [weak self] status in
                switch status {
                case .Success(let todo): print("success")
                    self?.showIndicator(false)
                    // show todo
                case .Failed(let error) : print("failed")
                    self?.showIndicator(false)
                    // show error
                case .Loading:
                    self?.showIndicator(true)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TodoDetailViewModel(todoId: todoId!)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.viewModel.updateTodo()
        }

    }
}

private extension TodoDetailViewController {
    func showIndicator(show: Bool) {
        if show { indicator.startAnimating() } else { indicator.stopAnimating() }
    }
    
    func _indicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        
        view.addConstraints([
            NSLayoutConstraint(item: indicator, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        ])
        
        return indicator
    }
}
