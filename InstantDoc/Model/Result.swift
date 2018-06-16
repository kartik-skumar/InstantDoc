//
//  Result.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 12/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import Foundation

struct Result {
    var id: String
    var name: String
    var desc: String
    var category: String
    
    var dictionary: [String:Any] {
        return [
            "name": name,
            "desc": desc,
            "category": category
        ]
    }
}

extension Result {
    init?(dictionary: [String : Any], id: String) {
        guard let name = dictionary["name"] as? String,
            let desc = dictionary["desc"] as? String,
            let category = dictionary["category"] as? String
            else { return nil }
        
        self.init(id: id, name: name, desc: desc, category: category)
    }
}
