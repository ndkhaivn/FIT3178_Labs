//
//  Person.swift
//  FIT3178-Lab02
//
//  Created by Nguyễn Đình Khải on 27/3/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    var name: String
    var house: String
    var age: Int
    
    init(name: String, house: String, age: Int) {
        self.name = name
        self.house = house
        self.age = age
    }
}
