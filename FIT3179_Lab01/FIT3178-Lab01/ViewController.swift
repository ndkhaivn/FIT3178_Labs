//
//  ViewController.swift
//  FIT3178-Lab01
//
//  Created by Nguyễn Đình Khải on 27/3/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    @IBAction func sayHello(_ sender: Any) {
        let name = nameField.text!
        
        guard let age = Int(ageField.text!) else {
            // Age could not be established. Print an error and exit
            displayMessage(title: "Error", msg: "Please enter a valid age value")
            return
        }
        
        let user = Person(name: name, age: age)
        displayMessage(title: "Greetings", msg: user.greeting())
    
    }
    
    func displayMessage(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

