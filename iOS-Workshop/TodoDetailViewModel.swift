//
//  TodoDetailViewModel.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation
import Firebase
import Argo

enum ConnectionStatus<Value, Error: ErrorType> {
    case Loading
    case Success(Value)
    case Failed(Error)
}

final class TodoDetailViewModel {
    
    let todoId: String
    private var todo: Todo?
    
    var status = Dynamic< ConnectionStatus<Todo, NSError> >(.Loading)
    
    private let firebase: Firebase
    
    init(todoId: String) {
        self.todoId = todoId
        
        firebase = Firebase(url: Constants.Firebase.baseURL + "/todos/\(self.todoId)")
        
        self.loadTodo(with: self.todoId)
    }
    
    private func loadTodo(with id: String) {
        
        firebase.removeAllObservers()
        
        status.value = .Loading
        
        firebase.keepSynced(true)
        firebase.observeEventType(.Value, withBlock: { [weak self] snapshot in
            guard snapshot.exists() else {
                self?.status.value = .Failed(.NoSnapshot)
                return
            }
            
            let todo = Todo.from(snapshot)
            guard let todoS = todo else {
                self?.status.value = .Failed(.NoSnapshot)
                return
            }
            
            self?.status.value = .Success(todoS)
            self?.todo = todoS
        })
    }
    
    func updateTodo() {
        self.todo!.notes = "fdhgihgir"
        firebase.setValue(self.todo!.toDictionary())
    }
}


private extension NSError {
    static var NoSnapshot: NSError {
        return NSError(
            domain: "TodoDetail",
            code: -1,
            userInfo: nil
        )
    }
}