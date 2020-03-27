//
//  ViewController.swift
//  FIT3178-Lab02
//
//  Created by Nguyễn Đình Khải on 27/3/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var houseSegmentedControl: UISegmentedControl!
    
    // Delegate callback for returning textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Assign delegate to return from keyboard
        nameField.delegate = self
        ageField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createHouseSegue" {
            let destination = segue.destination as! HouseViewController
            
            let name = nameField.text!
            let house = houseSegmentedControl.titleForSegment(at: houseSegmentedControl.selectedSegmentIndex)!
            var age: Int = 0
            if let enteredAge = Int(ageField.text!) {
                age = enteredAge
            }
            let newPerson = Person(name: name, house: house, age: age)
            destination.person = newPerson
            
        }
    }


}

