//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Isaac sam paul on 10/12/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import Foundation
import UIKit

class tableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var pin: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    
    
    let studentDetails = studentInformation.studentInformations
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! tableViewCell
        let student = studentDetails[indexPath.row]
        cell.title.text = student.name
        cell.location.text = student.location
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = studentDetails[indexPath.row]
        let mediaURL = student.mediaURL
        print(mediaURL)
        
        UIApplication.shared.openURL(URL(string: mediaURL)!)
        
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        self.uiEnable(Status: false)
        let network = NetworkCodes()
        network.getStudentLocations { (sucess, error) in
            if sucess == true
            {
                performUIUpdatesOnMain {
                self.uiEnable(Status: true)
                self.table.reloadData()
                }
            }
            else if error == "The Internet connection appears to be offline."
            {
                performUIUpdatesOnMain {
                    self.uiEnable(Status: true)
                    let alert = UIAlertController()
                    alert.title = "Cannot Connect To Server"
                    alert.message = "Please Check Your Internet Connection"
                    let continueAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){
                        
                        action in alert.dismiss(animated: true, completion: nil)
                        
                    }
                    alert.addAction(continueAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else
            {
                self.uiEnable(Status: true)
                print(error)
            }
        }
    }
    
    @IBAction func pin(_ sender: AnyObject) {
        
        if constants.udacity.objectId == ""
        {
            performSegue(withIdentifier: "locationViewController", sender: self)
        }
        else
        {
            let alert = UIAlertController()
            alert.title = "Do you wish to overwrite"
            alert.message = "You have already updated Your Location"
            let continueAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default){
                
                action in self.performSegue(withIdentifier: "locationViewController", sender: self)
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default){
                
                action in alert.dismiss(animated: true, completion: nil)
                
            }
            alert.addAction(continueAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    @IBAction func logOut(_ sender: AnyObject) {
        self.uiEnable(Status: false)
        let network = NetworkCodes()
        network.logout { (sucess, error) in
            if sucess == true
            {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "logInViewController") as? UINavigationController
                self.present(controller!, animated: true, completion: nil)
            }
            else
            {
                self.uiEnable(Status: true)
                print(error)
            }
        }

    }
    
    func uiEnable(Status: Bool)
    {
        logout.isEnabled = Status
        pin.isEnabled = Status
        refresh.isEnabled = Status
    }
}
