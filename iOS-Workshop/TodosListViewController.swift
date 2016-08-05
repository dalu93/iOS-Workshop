//
//  ViewController.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import UIKit

class TodosListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.addSubview(refreshControl)
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = self._refreshControl()
    
    private var viewModel: TodosListViewModel! {
        didSet {
            viewModel.todos.bind { [weak self] _ in
                guard let `self` = self else { return }
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let apiController = APIController()
        viewModel = TodosListViewModel(controller: apiController)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        viewModel.loadTodos()
    }
}
private extension TodosListViewController {
    func _refreshControl() -> UIRefreshControl {
        let control = UIRefreshControl()
        control.addTarget(
            self,
            action: #selector(TodosListViewController.loadData),
            forControlEvents: .ValueChanged
        )
        return control
    }
}

extension TodosListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todos.value.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let todo = viewModel.todos.value.get(at: indexPath.row) else { return UITableViewCell() }
        
        let cell: TodoTableViewCell = tableView.dequeueCell()
        cell.set(with: todo)
        return cell
    }
}

extension TodosListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let todo = viewModel.todos.value.get(at: indexPath.row) else { return }
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TodoDetailViewController") as! TodoDetailViewController
        controller.todoId = "123456"
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension UITableView {
    func dequeueCell<T: ReusableView>() -> T {
        guard let cell = self.dequeueReusableCellWithIdentifier(T.identifier) as? T else {
            fatalError("Table cannot dequeue")
        }
        
        return cell
    }
}