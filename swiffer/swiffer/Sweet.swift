//
//  Sweet.swift
//  swiffer
//
//  Created by juran_k on 5/2/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Sweet {
    let key: String!
    let content: String!
    let addedByUser: String!
    let itemRef: FIRDatabaseReference?
    
    init(content: String,addedByUser: String, key: String = "") {
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        if let sweetContent = (snapshot.value as? NSDictionary)!["content"] as? String {
            content = sweetContent
        }
        else {
            content = ""
        }
        if let sweetUser = (snapshot.value as? NSDictionary)!["addedByUser"] as? String {
            addedByUser = sweetUser
        }
        else {
            addedByUser = ""
        }
    }
    func toAnyObject() -> AnyObject {
        return ["content": content, "addedByUser": addedByUser] as AnyObject
    }
}
