//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Isaac sam paul on 10/13/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import Foundation
import UIKit

struct studentInformation
{
    let name: String
    let location: String
    let mediaURL: String
    
    init(dictionary: [String : AnyObject])
    {
     let firstName = dictionary["firstName"] as! String
     let lastName = dictionary["lastName"] as! String
     self.name = "\(firstName) \(lastName)"
     self.location = dictionary["mapString"] as! String
     self.mediaURL = dictionary["mediaURL"] as! String 
    }
}

extension studentInformation
{
    static var studentInformations: [studentInformation] {
        
        var studentArray: [studentInformation] = []
        
        for d in constants.parse.studentLocations! {
            
            studentArray.append(studentInformation(dictionary: d))
        }
        
        return studentArray
    }
}
