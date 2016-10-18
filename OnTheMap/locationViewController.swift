//
//  locationViewController.swift
//  OnTheMap
//
//  Created by Isaac sam paul on 10/13/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class locationViewController: UIViewController,UITextFieldDelegate,MKMapViewDelegate
{
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var action: UIActivityIndicatorView!
    var didGetLocation: Bool = false
    
    override func viewDidLoad() {
        action.isHidden = true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        enteredLocation.enteredLocation = textField.text
        return true
    }
    
    
    
    @IBAction func submit(_ sender: AnyObject) {
        self.submitButton.isEnabled = false
        self.action.isHidden = false
        if self.textField.text == ""
        {
            print("Enter a location")
            performUIUpdatesOnMain {
                self.action.isHidden = true
                self.submitButton.isEnabled = true
                let alert = UIAlertController()
                alert.title = "Enter a Location"
                alert.message = "Please Enter a Location To Proceed Further"
                let continueAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){
                    
                   action in alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(continueAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            self.getLocation(completionHandlerForGeoLocation: { (sucess) in
                if sucess == true
                {   self.submitButton.isEnabled = true
                    self.performSegue(withIdentifier: "urlViewController", sender: self)
                }
            })
        }
    }
    
    func getLocation(completionHandlerForGeoLocation: @escaping(_ sucess: Bool) -> Void )
    {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(enteredLocation.enteredLocation!, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) in
    
            guard error == nil else
            {
                
                let error = ((error?.localizedDescription)!)
                print(error)
                if error == "The operation couldn’t be completed. (kCLErrorDomain error 2.)"
                {
                    print(error)
                    performUIUpdatesOnMain {
                        self.submitButton.isEnabled = true
                        self.action.isHidden = true
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
                else if error == "The operation couldn’t be completed. (kCLErrorDomain error 8.)"
                {
                    performUIUpdatesOnMain {
                        self.submitButton.isEnabled = true
                        self.action.isHidden = true
                        let alert = UIAlertController()
                        alert.title = "Location Not Found"
                        alert.message = "Please try another Location"
                        let continueAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){
                            
                            action in alert.dismiss(animated: true, completion: nil)
                            
                        }
                        alert.addAction(continueAction)
                        self.present(alert, animated: true, completion: nil)
                    }

                }
                
                return
            }
            guard let placemark = placemarks else
            {
                print("no placemark available")
                return
            }
           guard let latitide = placemark[0].location?.coordinate.latitude else
           {
            
            print("couldnt copy")
            return
            }
            guard let longitude = placemark[0].location?.coordinate.longitude else
            {
                
                print("couldnt copy")
                return
            }
            enteredLocation.latitide = latitide
            enteredLocation.longitude = longitude
            self.action.isHidden = true
            completionHandlerForGeoLocation(true)
            
        })
    
    
    }
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    }

    
