//
//  ViewController.swift
//  OnTheMap
//
//  Created by Isaac sam paul on 10/11/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import UIKit
import Foundation


class UdacityLogIn: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var action: UIActivityIndicatorView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.action.isHidden = true

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func logIn(_ sender: AnyObject) {
        uiEnabled(status: false)
        if userName.text! == "" || password.text! == ""
        {
            debugLabel.text = "Please Enter UserName and Password"
            uiEnabled(status: true)
        }
        else if userName.text! != "" && password.text! != ""
        {
            self.action.isHidden = false
            debugLabel.text = ""
            let network = NetworkCodes()
            let httpBody = "{\"udacity\": {\"username\": \"\(self.userName.text!)\", \"password\": \"\(self.password.text!)\"}}"
            network.postUdacityApi(method: methods.udacityLogIn, httpBody: httpBody,range: 5 ,completionHandlerForPost: { (datadictionary, error) in
                guard error == "" else
                {
                    print(error)
                    if error == "The Internet connection appears to be offline."
                    {
                        performUIUpdatesOnMain {
                        self.debugLabel.text = "Check your internet connection"
                        self.uiEnabled(status: true)
                        }
                    }
                    else
                    {
                    self.displayError()
                        self.action.isHidden = true
                    }
                    return
                }
                guard let data = datadictionary as? NSDictionary else
                {
                   print("Could not get data")
                    self.displayError()
                    return 
                }
                
                guard let accountDetails = data["account"] as? NSDictionary else
                {
                    print("Cant get the account details")
                    self.displayError()
                    return
                }
                
                guard let userId = accountDetails["key"] as? String else
                {
                    print("Cant get user ID")
                    return
                }
                
                constants.udacity.userID = userId
                
                guard let sessionDetails = data["session"] as? NSDictionary else
                {
                    print("Couldnt get session id details")
                    return
                }

                guard let sessionID = sessionDetails["id"] as? String else
                {
                    print("cant get session id")
                    return
                }
                constants.udacity.sessionID = sessionID
                
                network.get(method: methods.getUserDetails,range: 5 ,completionHandlerForGet: { (dataDictionary, error) in
                    guard error == "" else
                    {
                        print(error)
                        self.displayError()
                        return
                    }
                    guard let data = dataDictionary as? NSDictionary else
                    {
                        print("Could not get data")
                        self.displayError()
                        return
                    }
                    print(data)
                    guard let user = data["user"] as? [String: AnyObject] else
                    {
                        print("No user data")
                        return
                    }
                    
                    guard let firstName = user["first_name"] as? String else
                    {
                        print("couldnt get first Name")
                        return
                    }
                    
                    guard let lastName = user["last_name"] as? String else
                    {
                        print("couldnt get last Name")
                        return
                    }
                    constants.udacity.firstName = firstName
                    constants.udacity.lastName = lastName
                    let name = "\(firstName) \(lastName)"
                    constants.udacity.userName = name
                    network.getStudentLocations(completionHandlerForLocations: { (sucess,locationError) in
                        if sucess == true
                        {
                            self.completeLogIn()
                            self.action.isHidden = true
                            self.uiEnabled(status: true)
                        }
                        else
                        {
                            self.action.isHidden = true
                            self.displayError()
                            print(locationError)
                        }
                        
                        
                    })

                    
                })

                
            })
            
        }
    }
    
    func displayError()
    {
        performUIUpdatesOnMain {
            self.debugLabel.text = "UserName or Password does not exist"
            self.uiEnabled(status: true)
        }
    }
    
    func uiEnabled(status: Bool)
    {
        userName.isEnabled = status
        password.isEnabled = status
        logInButton.isEnabled = status
        action.isHidden = status
    }
    
    func completeLogIn()
    {
        performUIUpdatesOnMain {
        let tabViewController = self.storyboard!.instantiateViewController(withIdentifier: "TabViewController") as! UITabBarController
        self.present(tabViewController, animated: true, completion: nil)
        }
    }
    
}
    
   




