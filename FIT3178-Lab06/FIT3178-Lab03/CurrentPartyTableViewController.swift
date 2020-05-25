//
//  CurrentPartyTableViewController.swift
//  FIT3178-Lab03
//
//  Created by Nguyễn Đình Khải on 3/4/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class CurrentPartyTableViewController: UITableViewController, AddSuperHeroDelegate, DatabaseListener {
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .team
    

    let SECTION_PARTY = 0;
    let SECTION_INFO = 1;
    let CELL_HERO = "heroCell";
    let CELL_INFO = "partySizeCell";
    
    var currentParty: [SuperHero] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - Database Listener
    func onTeamChange(change: DatabaseChange, teamHeroes: [SuperHero]) {
        currentParty = teamHeroes
        tableView.reloadData()
    }
    
    func onHeroListChange(change: DatabaseChange, heroes: [SuperHero]) {
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_PARTY:
                return currentParty.count
            case SECTION_INFO:
                return 1
            default:
                return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_PARTY {
            let partyCell =
                tableView.dequeueReusableCell(withIdentifier: CELL_HERO, for: indexPath)
                as! SuperHeroTableViewCell
            let hero = currentParty[indexPath.row]
            
            partyCell.nameLabel.text = hero.name
            partyCell.abilitiesLabel.text = hero.abilities
            
            return partyCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        
        cell.textLabel?.textColor = .secondaryLabel
        cell.selectionStyle = .none
        if currentParty.count > 0 {
            cell.textLabel?.text = "\(currentParty.count)/6 heroes in Party"
        } else {
            cell.textLabel?.text = "No heroes in party. Click + to add some"
        }
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_PARTY {
            return true
        }
        return false
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_PARTY {
            self.databaseController?.removeHeroFromTeam(hero: currentParty[indexPath.row], team: databaseController!.defaultTeam)
        }
    }

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
        if segue.identifier == "allHeroesSegue" {
            let destination = segue.destination as! AllHeroesTableViewController
            destination.superHeroDelegate = self
        }
    }
    
    // MARK: - AddSuperHero Delegate
    func addSuperHero(newHero: SuperHero) -> Bool {
        return databaseController!.addHeroToTeam(hero: newHero, team: databaseController!.defaultTeam)
    }
    

}
