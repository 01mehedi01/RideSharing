//
//  LoginController.swift
//  Cloude
//
//  Created by Mehedi Hasan on 17/12/19.
//  Copyright © 2019 Mehedi Hasan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

    @IBOutlet weak var userNamelavel: UILabel!
    @IBOutlet weak var emailTextView: UITextField!
    
    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBOutlet weak var errorLabell: UILabel!
    
    var usernameRider = true
    
    let backgroundImageView = UIImageView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabell.alpha = 0
        setBackground()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        
        let email = emailTextView.text!.trimmingCharacters(in: .whitespaces)
        let password = passwordTextView.text!.trimmingCharacters(in: .whitespaces)

        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil{
                self.errorLabell.text = err!.localizedDescription
                self.errorLabell.alpha = 1
            }else{
               // self.TransitionToHome()
                 let user = Auth.auth().currentUser
                print("Current User => \(String(describing: user))")
                
                if(user?.displayName == "Rider"){
                    print("Rider")
                    self.performSegue(withIdentifier: "readerVC", sender: nil)
                }else if(user?.displayName == "Driver"){
                    print("Driver")
                    self.performSegue(withIdentifier: "driverVC", sender: nil)
                }
               // self.performSegue(withIdentifier: "readerVC", sender: nil)
            }
        }
        
    
        //self.TransitionToHome()
       // performSegue(withIdentifier: "readerVC", sender: nil)
        
    }
    
    @IBAction func ErrorButton(_ sender: UIButton) {
    }
    
    
    ///*********************** Transition To Main Page ***********************
    func TransitionToHome() {
    
      let homeViewControll =   storyboard?.instantiateViewController(withIdentifier: Constant.StoryBord.homeViewController) as? ViewController
        
        view.window?.rootViewController = homeViewControll
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func SwitchAccount(_ sender: Any) {
        
        
        
       
        if usernameRider == true {
            
             self.userNamelavel.text = "Driver"
             usernameRider = false
        }else{
            self.userNamelavel.text = "Rider"
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
        
        backgroundImageView.image = UIImage(named: "loginback")
        view.sendSubviewToBack(backgroundImageView)
    }
    

}
