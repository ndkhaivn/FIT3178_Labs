//
//  HouseViewController.swift
//  FIT3178-Lab02
//
//  Created by Nguyễn Đình Khải on 27/3/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class HouseViewController: UIViewController {

    var person: Person?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var houseLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let person = person else {
            return
        }
        
        nameLabel.text = "Name: \(person.name)"
        ageLabel.text = "Age: \(person.age)"
        houseLabel.text = "House: \(person.house)"
        
        switch person.house {
            case "Lannister":
                houseLabel.textColor = UIColor(named: "LannisterColor")
            case "Tully":
                houseLabel.textColor = UIColor(named: "TullyColor")
            case "Stark":
                houseLabel.textColor = UIColor(named: "StarkColor")
            case "Tyrell":
                houseLabel.textColor = UIColor(named: "TyrellColor")
            case "Baratheon":
                houseLabel.textColor = UIColor(named: "BaratheonColor")
            default:
                houseLabel.textColor = UIColor.label
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
