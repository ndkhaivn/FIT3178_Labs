//
//  Person.swift
//  FIT3178-Lab01
//
//  Created by Nguyễn Đình Khải on 27/3/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func greeting() -> String {
        return "Hello \(name), you are \(age) year(s) old!"
    }
}
