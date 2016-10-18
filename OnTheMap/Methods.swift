//
//  Methods.swift
//  OnTheMap
//
//  Created by Isaac sam paul on 10/14/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import Foundation

struct methods
{
    static var udacityLogIn = "https://www.udacity.com/api/session"
    static var getUserDetails = "https://www.udacity.com/api/users/\(constants.udacity.userID)"
    static var getStudentLocations = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
    static var postStudentLocations = "https://parse.udacity.com/parse/classes/StudentLocation"
    static var updateStudentLocations = "https://parse.udacity.com/parse/classes/StudentLocation/\(constants.udacity.objectId)"
}
