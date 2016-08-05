//
//  TodosListViewModel.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation
import Argo

final class TodosListViewModel {
    
    let controller: APIController

    var todos = Dynamic<[Todo]>([])
    
    init(controller: APIController) {
        self.controller = controller
    }
    
    func loadTodos() {
        load(Todo.All) { result in
            switch result {
            case .Success(let todos): self.todos.value = todos
            default: break
            }
        }
    }
    
    func loadTodo(with id: String) {
        load(Todo.One(id)) { result in
            switch result {
            case .Success(let todo): break
            default: break
            }
        }
    }
    
    private func load<A>(resource: Resource<A>, completion: Completion<A, NSError> -> ()) {
        controller.load(endpoint: resource.endpoint) { result in
            
            switch result {
            case .Success(let json):
                
                guard let todo = resource.parseJSON(json) else { return }
                completion(.Success(todo))
                
            case .Failed: break
            }
        }
    }
}