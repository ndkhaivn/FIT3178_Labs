//
//  FirebaseController.swift
//  FIT3178-Lab04
//
//  Created by Nguyễn Đình Khải on 26/5/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    let DEFAULT_TEAM_NAME = "Default Team"
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var heroesRef: CollectionReference?
    var teamsRef: CollectionReference?
    var heroList: [SuperHero]
    var defaultTeam: Team
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        heroList = [SuperHero]()
        defaultTeam = Team()
        
        super.init()
        
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            self.setUpHeroListener()
        }
    }
    
    // MARK:- Setup code for Firestore listeners
    func setUpHeroListener() {
        heroesRef = database.collection("superheroes")
        heroesRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseHeroesSnapshot(snapshot: querySnapshot)
            
            self.setUpTeamListener()
        }
    }
    
    func setUpTeamListener() {
        teamsRef = database.collection("teams")
        teamsRef?.whereField("name", isEqualTo: DEFAULT_TEAM_NAME).addSnapshotListener {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot, let teamSnapshot = querySnapshot.documents.first else {
                print("Error fetching teams: \(error!)")
                return
            }
            self.parseTeamSnapshot(snapshot: teamSnapshot)
        }
    }
    
    // MARK:- Parse Functions for Firebase Firestore responses
    func parseHeroesSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let heroID = change.document.documentID
            print(heroID)
            
            var parsedHero: SuperHero?
            
            do {
                parsedHero = try change.document.data(as: SuperHero.self)
            } catch {
                print("Unable to decode hero. Is the hero malformed?")
                return
            }
            
            guard let hero = parsedHero else {
                print("Document doesn't exist")
                return;
            }
            
            hero.id = heroID
            if change.type == .added {
                heroList.append(hero)
            }
            else if change.type == .modified {
                let index = getHeroIndexByID(heroID)!
                heroList[index] = hero
            }
            else if change.type == .removed {
                if let index = getHeroIndexByID(heroID) {
                    heroList.remove(at: index)
                }
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.heroes ||
                listener.listenerType == ListenerType.all {
                listener.onHeroListChange(change: .update, heroes: heroList)
            }
        }
    }
    
    func parseTeamSnapshot(snapshot: QueryDocumentSnapshot) {
        defaultTeam = Team()
        defaultTeam.name = snapshot.data()["name"] as! String
        defaultTeam.id = snapshot.documentID
        
        if let heroReferences = snapshot.data()["heroes"] as? [DocumentReference] {
            // If the document has a "heroes" field, add heroes.
            for reference in heroReferences {
                if let hero = getHeroByID(reference.documentID) {
                    defaultTeam.heroes.append(hero)
                }
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.team ||
                listener.listenerType == ListenerType.all {
                listener.onTeamChange(change: .update, teamHeroes: defaultTeam.heroes)
            }
        }
    }
    
    // MARK:- Utility Functions
    func getHeroIndexByID(_ id: String) -> Int? {
        if let hero = getHeroByID(id) {
            return heroList.firstIndex(of: hero)
        }
        
        return nil
    }
    
    func getHeroByID(_ id: String) -> SuperHero? {
        for hero in heroList {
            if hero.id == id {
                return hero
            }
        }
        
        return nil
    }
    // MARK:- Required Database Functions
    func cleanup() {
        
    }
    
    func addSuperHero(name: String, abilities: String) -> SuperHero {
        let hero = SuperHero()
        hero.name = name
        hero.abilities = abilities
        
        do {
            if let heroRef = try heroesRef?.addDocument(from: hero) {
                hero.id = heroRef.documentID
            }
        } catch {
            print("Failed to serialize hero")
        }
        
        return hero
    }
    
    func addTeam(teamName: String) -> Team {
        let team = Team()
        team.name = teamName
        if let teamRef = teamsRef?.addDocument(data: ["name" : teamName, "heroes": []]) {
            team.id = teamRef.documentID
        }
        return team
    }
    
    func addHeroToTeam(hero: SuperHero, team: Team) -> Bool {
        
        guard let heroID = hero.id, let teamID = team.id,
            team.heroes.count < 6 else {
                return false
        }
        
        if let newHeroRef = heroesRef?.document(heroID) {
            teamsRef?.document(teamID).updateData(
                ["heroes" : FieldValue.arrayUnion([newHeroRef])]
            )
        }
        return true
    }
    
    func deleteSuperHero(hero: SuperHero) {
        if let heroID = hero.id {
            heroesRef?.document(heroID).delete()
        }
    }
    
    func deleteTeam(team: Team) {
        if let teamID = team.id {
            teamsRef?.document(teamID).delete()
        }
    }
    
    func removeHeroFromTeam(hero: SuperHero, team: Team) {
        if team.heroes.contains(hero), let teamID = team.id,
            let heroID = hero.id {
            if let removedRef = heroesRef?.document(heroID) {
                teamsRef?.document(teamID).updateData(
                    ["heroes": FieldValue.arrayRemove([removedRef])]
                )
            }
        }
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.team ||
            listener.listenerType == ListenerType.all {
            listener.onTeamChange(change: .update, teamHeroes: defaultTeam.heroes)
        }
        
        if listener.listenerType == ListenerType.heroes ||
            listener.listenerType == ListenerType.all {
            listener.onHeroListChange(change: .update, heroes: heroList)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
}
