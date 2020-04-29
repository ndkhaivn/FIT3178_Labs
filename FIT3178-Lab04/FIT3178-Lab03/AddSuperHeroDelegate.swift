//
//  AddSuperHeroDelegate.swift
//  FIT3178-Lab03
//
//  Created by Nguyễn Đình Khải on 3/4/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

protocol AddSuperHeroDelegate: AnyObject {
    func addSuperHero(newHero: SuperHero) -> Bool
}
