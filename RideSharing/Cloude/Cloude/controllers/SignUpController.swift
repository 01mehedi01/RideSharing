//
//  SignUpController.swift
//  Cloude
//
//  Created by Mehedi Hasan on 17/12/19.
//  Copyright © 2019 Mehedi Hasan. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var errorbtn: UILabel!
    @IBOutlet weak var errorviewLabel: UILabel!
    @IBOutlet weak var firstNmaetextView: UITextField!
    
    @IBOutlet weak var lastNameTextView: UITextField!
    
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    let backgroundImageView = UIImageView()
    
    var usernameRider = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorviewLabel.alpha = 0
        setBackground()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func SignUpButton(_ sender: UIButton) {
         print("Cool => ")
       
        let firstName = firstNmaetextView.text!.trimmingCharacters(in: .whitespaces)
        let lasttName = lastNameTextView.text!.trimmingCharacters(in: .whitespaces)
        let email =     emailTextView.text!.trimmingCharacters(in: .whitespaces)
        let password =  passwordTextView.text!.trimmingCharacters(in: .whitespaces)
        
         let error = validTextFild()
        self.errorviewLabel.text = password
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            
            if err != nil{
                print("nill")
            }else{
                
                if self.usernameRider == true{
                    let req = Auth.auth().currentUser?.createProfileChangeRequest()
                    req?.displayName = "Rider"
                    req?.commitChanges(completion: nil)
                }else{
                     let req = Auth.auth().currentUser?.createProfileChangeRequest()
                     req?.displayName = "Driver"
                     req?.commitChanges(completion: nil)
                }
                
                //***************** Create User *********************
                print("Create")
                self.performSegue(withIdentifier: "loginVC", sender: nil)
//               self.errorviewLabel.text = password
//               self.errorviewLabel.alpha = 1
                
            }
        }
    }
    
    
    
    
    func validTextFild() -> String? {
        if (firstNmaetextView.text?.trimmingCharacters(in: .whitespaces)) == "" ||
            (lastNameTextView.text?.trimmingCharacters(in: .whitespaces)) == "" ||
            (emailTextView.text?.trimmingCharacters(in: .whitespaces)) == "" ||
            (passwordTextView.text?.trimmingCharacters(in: .whitespaces)) == "" {
            return "Please feel All field"
        }
        
        return nil
        
        
        
    }
    

    
    @IBAction func ErrorButton(_ sender: UIButton) {
    }
    
    @IBAction func SwitchAccount(_ sender: Any) {
        
        if usernameRider == true {
            
            self.usernameLabel.text = "Driver"
            usernameRider = false
        }else{
            self.usernameLabel.text = "Rider"
            usernameRider = true
        }
    }
    
    func setBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backgroundImageView.image = UIImage(named: "signback")
        view.sendSubviewToBack(backgroundImageView)
    }
    
}
