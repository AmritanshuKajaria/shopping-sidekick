//
//  LoginViewController.swift
//  shopping-sidekick
//
//  Created by Amritanshu Kajaria on 12/11/16.
//  Copyright © 2016 Amritanshu Kajaria. All rights reserved.
//

import UIKit
//import FacebookCore
//import FacebookLogin
import FBSDKLoginKit
import FirebaseAuth


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var activityIndicatorSpinner: UIActivityIndicatorView!
    var loginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.isHidden = true
        
        
        FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if FIRAuth.auth()?.currentUser != nil {
                // User is signed in.
                // ...
                
                let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "showPageView")
                
                
                self.present(homeViewController, animated:true, completion:nil)
                
                
                
            } else {
                
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                self.view.addSubview(self.loginButton)
                
                self.loginButton.isHidden = false
                
                // No user is signed in.
                // ...
            }
        }

//        // Do any additional setup after loading the view.
//        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
//        loginButton.center = view.center
//        view.addSubview(loginButton)
        
        
        // Optional: Place the button in the center of your view.
        

        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        self.loginButton.isHidden = true
        activityIndicatorSpinner.startAnimating()
        
        
        print("User Logged IN")
        
        
        if error != nil {
            self.loginButton.isHidden = false
            activityIndicatorSpinner.stopAnimating()
            return
        }
        else if(result.isCancelled)
        {
            self.loginButton.isHidden = false
            activityIndicatorSpinner.stopAnimating()
            return
        }
        else{
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                print("User Logged IN on firebase")
                if error != nil {
                    print(error ?? "")
                    return
                }
            }

            
        }
        
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User did logged Out")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
