//
//  Todo.swift
//  iOS-Workshop
//
//  Created by Luca D'Alberti on 8/5/16.
//  Copyright © 2016 dalu93. All rights reserved.
//

import Foundation
//import SwiftyJSON
import Argo
import Curry
import Firebase

struct Todo {
    let id: String
    let name: String
    var notes: String
    private let imgUrlStr: String
}

extension Todo {
    var imgUrl: NSURL { return NSURL(string: imgUrlStr)! }
}

//extension Todo {
//    init?(json: JSON) {
//        guard
//            let id = json["id"].string,
//            let name = json["name"].string,
//            let notes = json["notes"].string,
//            let imgUrl = json["img_url"].string else { return nil }
//        
//        self.id = id
//        self.name = name
//        self.notes = notes
//        self.imgUrl = imgUrl
//    }
//}

extension Todo {
    static func from(snapshot: FDataSnapshot) -> Todo? {
        guard let snapshotValue = snapshot.value as? [String : AnyObject] else { return nil }
        
        let name = snapshotValue["name"] as! String
        let notes = snapshotValue["notes"] as! String
        let img = snapshotValue["img_url"] as! String
        return Todo(
            id: snapshot.key,
            name: name,
            notes: notes,
            imgUrlStr: img
        )
    }
}

extension Todo {
    func toDictionary() -> [String : AnyObject] {
        return [
            "name": self.name,
            "notes": self.notes,
            "img_url": self.imgUrlStr
        ]
    }
}

extension Todo: Decodable {
    static func decode(json: JSON) -> Decoded<Todo> {
        return curry(self.init)
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "notes"
            <*> json <| "img_url"
    }
}

extension Todo {
    static var All: Resource<[Todo]> {
        return Resource<[Todo]>(
            endpoint: Endpoint(
                path: "/todos.json",
                httpMethod: .GET,
                headers: nil,
                paramters: nil
            ),
            parseJSON: { json -> [Todo]? in
                guard let todosDictionary = json["todos"] as? [JSONDictionary] else { return nil }
                
                let todos: [Todo] = todosDictionary.flatMap {
                    let decodedTodo: Decoded<Todo> = decode(JSON($0))
                    
                    switch decodedTodo {
                    case .Success(let todo):
                        return todo
                    case .Failure: return nil
                    }
                }
                
                return todos
            }
        )
    }
    
    static func One(id: String) -> Resource<Todo> {
        return Resource<Todo>(
            endpoint: Endpoint(
                path: "/todos/\(id).json",
                httpMethod: .GET,
                headers: nil,
                paramters: nil
            ),
            parseJSON: { json -> Todo? in
                
                switch decode(JSON(json)) {
                case .Success(let todo):
                    return todo
                    
                case .Failure: return nil
                }
            }
        )
    }
}