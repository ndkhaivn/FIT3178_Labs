//
//  AllHeroesTableViewController.swift
//  FIT3178-Lab03
//
//  Created by Nguyễn Đình Khải on 3/4/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class AllHeroesTableViewController: UITableViewController, AddSuperHeroDelegate, UISearchResultsUpdating {

    let SECTION_HEROES = 0
    let SECTION_INFO = 1
    let CELL_HERO = "heroCell"
    let CELL_INFO = "totalHeroesCell"
    
    var allHeroes: [SuperHero] = []
    var filteredHeroes: [SuperHero] = []
    weak var superHeroDelegate: AddSuperHeroDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDefaultHeroes()
        
        filteredHeroes = allHeroes
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Heroes"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }

    // MARK: - Search Controller Delegate
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        if searchText.count > 0 {
            filteredHeroes = allHeroes.filter({(hero: SuperHero) -> Bool in
                return hero.name.lowercased().contains(searchText)
            })
        } else {
            filteredHeroes = allHeroes
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_HEROES {
            return filteredHeroes.count
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_HEROES {
            let heroCell = tableView.dequeueReusableCell(withIdentifier: CELL_HERO,
                                                         for: indexPath) as! SuperHeroTableViewCell
            let hero = filteredHeroes[indexPath.row]
            heroCell.nameLabel.text = hero.name
            heroCell.abilitiesLabel.text = hero.abilities
            
            return heroCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        cell.textLabel?.text = "\(filteredHeroes.count) heroes in the database"
        cell.textLabel?.textColor = .secondaryLabel
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_INFO {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        if superHeroDelegate?.addSuperHero(newHero: filteredHeroes[indexPath.row]) ?? false {
            navigationController?.popViewController(animated: false)
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        displayMessage(title: "Party Full", message: "Unable to add more members to party")
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createHeroSegue" {
            let destination = segue.destination as! CreateSuperHeroViewController
            destination.superHeroDelegate = self
        }
    }
    
    // MARK: - AddSuperHero Delegate
    
    func addSuperHero(newHero: SuperHero) -> Bool {
        allHeroes.append(newHero)
        filteredHeroes.append(newHero)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: filteredHeroes.count - 1, section: 0)],
                             with: .automatic)
        tableView.endUpdates()
        tableView.reloadSections([SECTION_INFO], with: .automatic)
        return true
    }
    
    // MARK: - Create Defaults
    
    func createDefaultHeroes() {
        allHeroes.append(SuperHero(name: "Bruce Wayne", abilities: "Money"))
        allHeroes.append(SuperHero(name: "Superman", abilities: "Super Powered Alien"))
        allHeroes.append(SuperHero(name: "Wonder Woman", abilities: "Goddess"))
        allHeroes.append(SuperHero(name: "The Flash", abilities: "Spped"))
        allHeroes.append(SuperHero(name: "Green Lantern", abilities: "Power Ring"))
        allHeroes.append(SuperHero(name: "Cyborg", abilities: "Robot Beep Beep"))
        allHeroes.append(SuperHero(name: "Aquaman", abilities: "Atlantian"))
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
