//
//  UrlViewController.swift
//  OnTheMap
//
//  Created by Isaac sam paul on 10/13/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UrlViewController: UIViewController,MKMapViewDelegate,UITextFieldDelegate,UINavigationBarDelegate
{
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var action: UIActivityIndicatorView!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    let network = NetworkCodes()
    var coordinate: CLLocationCoordinate2D!
    var annotation: [MKPointAnnotation] = []
    override func viewWillAppear(_ animated: Bool) {
        action.isHidden = true
        let coordinate = CLLocationCoordinate2DMake(enteredLocation.latitide!, enteredLocation.longitude!)
        self.coordinate = coordinate
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(region, animated: true)
        makeAnnotation()
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enteredLocation.enteredURL = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    func makeAnnotation()
    {
        let annotation = MKPointAnnotation()
        annotation.title = constants.udacity.userName
        annotation.coordinate = self.coordinate
        annotation.subtitle = textField.text
        self.annotation.append(annotation)
        self.mapView.addAnnotations(self.annotation)
    }
    
    func updateTheList(completionHandlerForUpdatingList: @escaping(_ sucess: Bool) -> Void )
    {
        self.UIEnable(status: false)
        makeAnnotation()
        let httpBody = "{\"uniqueKey\": \"\(constants.udacity.userID)\", \"firstName\": \"\(constants.udacity.firstName)\", \"lastName\": \"\(constants.udacity.lastName)\",\"mapString\": \"\(enteredLocation.enteredLocation!)\", \"mediaURL\": \"\(enteredLocation.enteredURL!)\",\"latitude\": \(enteredLocation.latitide!), \"longitude\": \(enteredLocation.longitude!)}"
        
        if constants.udacity.objectId == ""
        {
            self.network.postParseApi(method: methods.postStudentLocations, httpBody: httpBody,range: 0) { (data, error) in
                guard error == "" else
                {
                    if error == "The Internet connection appears to be offline."
                    {
                        
                        performUIUpdatesOnMain {
                            self.UIEnable(status: true)
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
                        print(error)
                    }
                    return
                }
                guard let data = data as? NSDictionary else
                {
                    print("Couldnt update the information")
                    return
                }
                guard let objectId = data["objectId"] as? String else
                {
                    print("Could not get objectId")
                    return
                }
                
                constants.udacity.objectId = objectId
                print(constants.udacity.objectId)
                
                self.network.getStudentLocations(completionHandlerForLocations: { (sucess, locationError) in
                    if sucess == true
                    {
                        performUIUpdatesOnMain {
                            self.UIEnable(status: true)
                            completionHandlerForUpdatingList(true)
                        }
                        
                    }
                        
                    else
                    {
                        print(locationError)
                    }
                })
            }
        }
        else
        {
            self.network.putParseApi(method: methods.updateStudentLocations, httpBody: httpBody,range: 0) { (data, error) in
                guard error == "" else
                {
                    if error == "The Internet connection appears to be offline."
                    {
                        
                        performUIUpdatesOnMain {
                            self.UIEnable(status: true)
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
                        print(error)
                    }
                    return
                }
                
                guard let data = data as? NSDictionary else
                {
                    print("Couldnt update the information")
                    return
                }
                
                print(data)
                
                self.network.getStudentLocations(completionHandlerForLocations: { (sucess, locationError) in
                    if sucess == true
                    {
                        performUIUpdatesOnMain {
                            self.UIEnable(status: true)
                            completionHandlerForUpdatingList(true)
                        }
                        
                    }
                        
                    else
                    {
                        print(locationError)
                    }
                })
            }
            
        }
   
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        self.UIEnable(status: false)
        if textField.text == ""
        {
            self.UIEnable(status: true)
            performUIUpdatesOnMain {
                let alert = UIAlertController()
                alert.title = "URL Field is Empty"
                alert.message = "Please Type a URL"
                let continueAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){
                    
                    action in alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(continueAction)
                self.present(alert, animated: true, completion: nil)
                
            }
                
            }
        else
        {
            self.updateTheList(completionHandlerForUpdatingList: { (sucess) in
                if sucess == true
                {
                    performUIUpdatesOnMain {
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as? UITabBarController
                        self.present(controller!, animated: true, completion: nil)
                    }
                }
                else
                {
                    self.UIEnable(status: true)
                }
            })
        }
            
        }
    
    @IBAction func back(_ sender: AnyObject) {
        performUIUpdatesOnMain {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        performUIUpdatesOnMain {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as? UITabBarController
            self.present(controller!, animated: true, completion: nil)
        }
    }

    func UIEnable(status: Bool)
    {
        submitButton.isEnabled = status
        action.isHidden = status
        textField.isEnabled = status
    }
    
   
    
}
