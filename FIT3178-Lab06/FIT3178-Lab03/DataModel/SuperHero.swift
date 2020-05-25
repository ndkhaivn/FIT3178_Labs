//
//  SuperHero.swift
//  FIT3178-Lab04
//
//  Created by Nguyễn Đình Khải on 25/5/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import Foundation

class SuperHero: NSObject, Codable {
    var id: String?
    var name: String? = ""
    var abilities: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case abilities
    }
}
