//
//  LoginViewController.swift
//  Parsetagram
//
//  Created by Nicole Mitchell on 6/20/16.
//  Copyright © 2016 Nicole Mitchell. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var invalidUsernamePassword: UIView!
    @IBOutlet weak var usernameTaken: UIView!
    @IBOutlet weak var enterPassword: UIView!
    @IBOutlet weak var enterUsername: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        invalidUsernamePassword.hidden = true
        usernameTaken.hidden = true
        enterPassword.hidden = true
        enterUsername.hidden = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetWarnings() {
        if self.invalidUsernamePassword.hidden == false {
            self.invalidUsernamePassword.hidden = true
        }
        if self.usernameTaken.hidden == false {
            self.usernameTaken.hidden = true
        }
        if self.enterPassword.hidden == false {
            self.enterPassword.hidden = true
        }
        if self.enterUsername.hidden == false {
            self.enterUsername.hidden = true
        }
        
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil {
                print("you're logged in")
                
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
            else {
                print(error?.localizedDescription)
                if error?.code == 101 {
                    print("invalid username or password")
                    self.resetWarnings()
                    self.invalidUsernamePassword.hidden = false
                    
                }
                
            }
            
            
        }
        
    }
    

    
    
    @IBAction func onSignUp(sender: AnyObject) {
        
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        
        
        newUser.signUpInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            if success {
                if newUser.username == "" {
                    self.resetWarnings()
                    self.enterUsername.hidden = false
                }
                else if newUser.password == "" {
                    self.resetWarnings()
                    self.enterPassword.hidden = false
                }
                else {
                    print("user created")
                
                self.performSegueWithIdentifier("loginSegue", sender: nil)
                }
                
            } else {
                print(error?.localizedDescription)
                if error?.code == 202 {
                    print("username is taken")
                    self.resetWarnings()
                    self.usernameTaken.hidden = false
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
