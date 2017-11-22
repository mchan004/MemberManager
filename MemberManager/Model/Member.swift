//
//  Member.swift
//  MemberManager
//
//  Created by Administrator on 11/21/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import Foundation

class Member: NSObject, NSCoding {
    var name, sex, detail: String
    var age: Int
    
    init(name: String, age: Int, sex: String, detail: String) {
        self.name = name
        self.age = age
        self.sex = sex
        self.detail = detail
    }

    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.age = aDecoder.decodeInteger(forKey: "age")
        self.sex = aDecoder.decodeObject(forKey: "sex") as! String
        self.detail = aDecoder.decodeObject(forKey: "detail") as! String
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(age, forKey: "age")
        aCoder.encode(sex, forKey: "sex")
        aCoder.encode(detail, forKey: "detail")
    }
    
}
