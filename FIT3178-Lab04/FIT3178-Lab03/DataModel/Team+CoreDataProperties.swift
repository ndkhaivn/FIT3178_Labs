//
//  Team+CoreDataProperties.swift
//  FIT3178-Lab04
//
//  Created by Nguyễn Đình Khải on 29/4/20.
//  Copyright © 2020 Monash University. All rights reserved.
//
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var name: String?
    @NSManaged public var heroes: NSSet?

}

// MARK: Generated accessors for heroes
extension Team {

    @objc(addHeroesObject:)
    @NSManaged public func addToHeroes(_ value: SuperHero)

    @objc(removeHeroesObject:)
    @NSManaged public func removeFromHeroes(_ value: SuperHero)

    @objc(addHeroes:)
    @NSManaged public func addToHeroes(_ values: NSSet)

    @objc(removeHeroes:)
    @NSManaged public func removeFromHeroes(_ values: NSSet)

}
