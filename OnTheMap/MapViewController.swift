//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Isaac sam paul on 10/12/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import Foundation
import MapKit


class mapView: UIViewController,MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var pin: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var annotations = [MKPointAnnotation]()
    override func viewDidLoad()
    {
        self.loadAnnotation()
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
    
    @IBAction func refresh(_ sender: AnyObject) {
        self.uiEnable(Status: false)
        let network = NetworkCodes()
        network.getStudentLocations { (sucess, error) in
            if sucess == true
            {
                performUIUpdatesOnMain {
                self.mapView.removeAnnotations(self.annotations)
                self.uiEnable(Status: true)
                self.loadAnnotation()
                }
            }
            else if error == "The Internet connection appears to be offline."
            {
                performUIUpdatesOnMain {
                    self.uiEnable(Status: true)
                    let alert = UIAlertController()
                    alert.title = "Cannot Connect To Server"
                    alert.message = "Please Check your Internet Connection"
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
    
    func uiEnable(Status: Bool)
    {
        activity.isHidden = Status
        logout.isEnabled = Status
        pin.isEnabled = Status
        refresh.isEnabled = Status
    }
    
    func loadAnnotation()
    {
        let locations = constants.parse.studentLocations!
        
        activity.isHidden = true
        
        for dictionary in locations
        {
            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary["firstName"] as! String
            let last = dictionary["lastName"] as! String
            let mediaURL = dictionary["mediaURL"] as! String
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            
            annotations.append(annotation)
            
        }
        self.mapView.addAnnotations(annotations)
  
    }

    
    
   }
