//
//  CoreDataController.swift
//  FIT3178-Lab04
//
//  Created by Nguyễn Đình Khải on 29/4/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    let DEFAULT_TEAM_NAME = "Default Team"
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    // Fetched Results Controllers
    var allHeroesFetchedResultsController: NSFetchedResultsController<SuperHero>?
    var teamHeroesFetchedResultsController: NSFetchedResultsController<SuperHero>?
    
    override init() {
        // Load the Core Data Stack
        persistentContainer = NSPersistentContainer(name: "Week04-SuperHeroes")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        super.init()
        
        // If no heroes in the database we assume this is the first time the app runs
        // Create a default team and inital super heroes in this case
        if fetchAllHeroes().count == 0 {
            createDefaultEntries()
        }
    }
    
    // MARK: - Lazy Initization of Default Team
    lazy var defaultTeam: Team = {
        var teams = [Team]()
        
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", DEFAULT_TEAM_NAME)
        request.predicate = predicate
        
        do {
            try teams = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        
        if teams.count == 0 {
            return addTeam(teamName: DEFAULT_TEAM_NAME)
        }
        
        return teams.first!
    }()
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
    }
    
    func cleanup() {
        saveContext()
    }
    
    func addSuperHero(name: String, abilities: String) -> SuperHero {
        let hero = NSEntityDescription.insertNewObject(forEntityName: "SuperHero", into: persistentContainer.viewContext) as! SuperHero
        hero.name = name
        hero.abilities = abilities
        
        return hero
    }
    
    func addTeam(teamName: String) -> Team {
        let team = NSEntityDescription.insertNewObject(forEntityName: "Team", into: persistentContainer.viewContext) as! Team
        team.name = teamName
        
        return team
    }
    
    func addHeroToTeam(hero: SuperHero, team: Team) -> Bool {
        guard let heroes = team.heroes, heroes.contains(hero) == false,
            heroes.count < 6 else {
                return false
        }
        team.addToHeroes(hero)
        
        return true
    }
    
    func deleteSuperHero(hero: SuperHero) {
        persistentContainer.viewContext.delete(hero)
    }
    
    func deleteTeam(team: Team) {
        persistentContainer.viewContext.delete(team)
    }
    
    func removeHeroFromTeam(hero: SuperHero, team: Team) {
        team.removeFromHeroes(hero)
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .team || listener.listenerType == .all {
            listener.onTeamChange(change: .update, teamHeroes: fetchTeamHeroes())
        }
        
        if listener.listenerType == .heroes || listener.listenerType == .all {
            listener.onHeroListChange(change: .update, heroes: fetchAllHeroes())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    // MARK: - Fetched Results Controller Protocol Functions
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allHeroesFetchedResultsController {
            listeners.invoke{ (listener) in
                if listener.listenerType == .heroes || listener.listenerType == .all {
                    listener.onHeroListChange(change: .update, heroes: fetchAllHeroes())
                }
            }
        } else if controller == teamHeroesFetchedResultsController {
            listeners.invoke{ (listener) in
                if listener.listenerType == .team || listener.listenerType == .all {
                    listener.onTeamChange(change: .update, teamHeroes: fetchTeamHeroes())
                }
            }
        }
    }
    
    // MARK: - Core Data Fetch Requests
    func fetchAllHeroes() -> [SuperHero] {
        // if results controller not currently initialized
        if allHeroesFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<SuperHero> = SuperHero.fetchRequest()
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            // initialize Results Controller
            allHeroesFetchedResultsController =
                NSFetchedResultsController<SuperHero>(fetchRequest: fetchRequest,
                                                      managedObjectContext: persistentContainer.viewContext,
                                                      sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allHeroesFetchedResultsController?.delegate = self
            
            do {
                try allHeroesFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var heroes = [SuperHero]()
        if allHeroesFetchedResultsController?.fetchedObjects != nil {
            heroes = (allHeroesFetchedResultsController?.fetchedObjects)!
        }
        
        return heroes
    }
    
    func fetchTeamHeroes() -> [SuperHero] {
        if teamHeroesFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<SuperHero> = SuperHero.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let predicate = NSPredicate(format: "ANY teams.name == %@", DEFAULT_TEAM_NAME)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            fetchRequest.predicate = predicate
            teamHeroesFetchedResultsController =
                NSFetchedResultsController<SuperHero>(fetchRequest: fetchRequest,
                                                      managedObjectContext: persistentContainer.viewContext,
                                                      sectionNameKeyPath: nil, cacheName: nil)
            teamHeroesFetchedResultsController?.delegate = self
            
            do {
                try teamHeroesFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var heroes = [SuperHero]()
        if teamHeroesFetchedResultsController?.fetchedObjects != nil {
            heroes = (teamHeroesFetchedResultsController?.fetchedObjects)!
        }
        
        return heroes
    }
    
    // MARK: - Default Entry Generation
    func createDefaultEntries() {
        let _ = addSuperHero(name: "Bruce Wayne", abilities: "Money")
        let _ = addSuperHero(name: "Superman", abilities: "Super Powered Alien")
        let _ = addSuperHero(name: "Wonder Woman", abilities: "Goddess")
        let _ = addSuperHero(name: "The Flash", abilities: "Speed")
        let _ = addSuperHero(name: "Green Lantern", abilities: "Power Ring")
        let _ = addSuperHero(name: "Cyborg", abilities: "Robot Beep Beep")
        let _ = addSuperHero(name: "Aquaman", abilities: "Atlantian")
    }
}
