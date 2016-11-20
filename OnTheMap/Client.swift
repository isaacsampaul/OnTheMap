//
//  Client.swift
//  OnTheMap
//
//  Created by Isaac sam paul on 10/14/16.
//  Copyright © 2016 Isaac sam paul. All rights reserved.
//

import Foundation
import UIKit

class NetworkCodes
{
    
    func postUdacityApi(method: String, httpBody: String, range: Int, completionHandlerForPost:@escaping (_ dataDictionary :Any,_ errorString :String) -> Void)
    {
        
        let method = method
        let url = NSURL(string: method)
        let request = NSMutableURLRequest(url: url as! URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){(data,response,error) in
            var errors = ""
            guard error == nil else
            {
                errors = "\((error?.localizedDescription)!)"
                print("Error while acessing data")
                completionHandlerForPost("", errors)
                return
            }
            
            guard let data = data else
            {
                print("Cant get the data")
                return
            }
            
            let r=Range(range...data.count)
            
            let newData = NSString(data: data.subdata(in: r), encoding: String.Encoding.utf8.rawValue)
            
            guard let newdata = newData?.data(using: String.Encoding.utf8.rawValue) else
            {
                print("unable to convert to data")
                return
            }
            
            var parsedJsonData: NSDictionary!
            do
            {
                parsedJsonData = try JSONSerialization.jsonObject(with: newdata, options: .allowFragments) as! NSDictionary
            }
            catch
            {
                print("Unable to parse data")
                return
            }
            
            completionHandlerForPost(parsedJsonData,errors)
           
        }
        
        task.resume()
        
    }
    
    func get(method: String, range: Int ,completionHandlerForGet: @escaping(_ dataDictionary :Any,_ errorString :String) -> Void)
    {
        let method = method
       
        let URL = NSURL(string: method)
        let request = NSMutableURLRequest(url: URL as! URL)
        let task = URLSession.shared.dataTask(with: request as! URLRequest){(data,response,error) in
            var errors = ""
            guard error == nil else
            {
                errors = "\(error)"
                print("Error occured while trying to get user information: \(error)")
                completionHandlerForGet("", errors)
                return
            }
            
            guard let data = data else
            {
                print("Cant retrieve user data")
                return
            }
            
            let r = Range(range...data.count)
            let newData = data.subdata(in: r)
            var parsedJsonData: NSDictionary!
            do
            {
                parsedJsonData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! NSDictionary
            }
            catch
            {
                print("couldnt parse the data")
                return
            }
            completionHandlerForGet(parsedJsonData,errors)
    }
        task.resume()
    }
    
    func getStudentLocations(completionHandlerForLocations: @escaping (_ sucess: Bool,_ error: String) -> Void)
    {
        let method = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
        let url = NSURL(string: method)
        let request = NSMutableURLRequest(url: url as! URL)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = URLSession.shared.dataTask(with: request as! URLRequest){(data,response,error) in
            guard error == nil else
            {
                print("Error while getting Student location")
                completionHandlerForLocations(false,(error?.localizedDescription)!)
                return
            }
            guard let data = data else
            {
                print("Couldnt get Student data")
                return
            }
            let r = Range(0...data.count)
            let newData = data.subdata(in: r)
            var parsedJsonData: NSDictionary!
            do
            {
                parsedJsonData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! NSDictionary
            }
            catch
            {
                print("couldnt parse the data")
                return
            }
            guard let studentLocations = parsedJsonData["results"] as?[[String:AnyObject]] else
            {
                print("Could not get the studentLocations")
                return
            }
            constants.parse.studentLocations = studentLocations
            print(constants.parse.studentLocations.count)
            completionHandlerForLocations(true,"")
        }
        task.resume()
    }
    
    func postParseApi(method: String, httpBody: String, range: Int, completionHandlerForPost:@escaping (_ dataDictionary :Any,_ errorString :String) -> Void)
    {
        
        let method = method
        let url = NSURL(string: method)
        let request = NSMutableURLRequest(url: url as! URL)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){(data,response,error) in
            var errors = ""
            guard error == nil else
            {
                errors = "\((error?.localizedDescription)!)"
                print("Error while acessing data")
                completionHandlerForPost("", errors)
                return
            }
            
            guard let data = data else
            {
                print("Cant get the data")
                return
            }
            
            let r=Range(range...data.count)
            
            let newData = NSString(data: data.subdata(in: r), encoding: String.Encoding.utf8.rawValue)
            
            guard let newdata = newData?.data(using: String.Encoding.utf8.rawValue) else
            {
                print("unable to convert to data")
                return
            }
            
            var parsedJsonData: NSDictionary!
            do
            {
                parsedJsonData = try JSONSerialization.jsonObject(with: newdata, options: .allowFragments) as! NSDictionary
            }
            catch
            {
                print("Unable to parse data")
                return
            }
            
            
            
            completionHandlerForPost(parsedJsonData,errors)
            
        }
        
        task.resume()
        
    }
    
    func putParseApi(method: String, httpBody: String, range: Int, completionHandlerForPost:@escaping (_ dataDictionary :Any,_ errorString :String) -> Void)
    {
        
        let method = method
        let url = NSURL(string: method)
        let request = NSMutableURLRequest(url: url as! URL)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){(data,response,error) in
            var errors = ""
            guard error == nil else
            {
                errors = "\((error?.localizedDescription)!)"
                print("Error while acessing data")
                completionHandlerForPost("", errors)
                return
            }
            
            guard let data = data else
            {
                print("Cant get the data")
                return
            }
            
            let r=Range(range...data.count)
            
            let newData = NSString(data: data.subdata(in: r), encoding: String.Encoding.utf8.rawValue)
            
            guard let newdata = newData?.data(using: String.Encoding.utf8.rawValue) else
            {
                print("unable to convert to data")
                return
            }
            
            var parsedJsonData: NSDictionary!
            do
            {
                parsedJsonData = try JSONSerialization.jsonObject(with: newdata, options: .allowFragments) as! NSDictionary
            }
            catch
            {
                print("Unable to parse data")
                return
            }
            
            
            
            completionHandlerForPost(parsedJsonData,errors)
            
        }
        
        task.resume()
        
    }
    
    func logout(completionHandlerForLogOut: @escaping (_ sucess: Bool,_ error: String) -> Void)
    {
        let method = methods.udacityLogIn
        let url = NSURL(string: method)
        let request = NSMutableURLRequest(url: url as! URL)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil else
            {
                completionHandlerForLogOut(false,(error?.localizedDescription)!)
                return
            }
            guard let data = data else
            {
                print("Cant get the data")
                return
            }
            
            let r=Range(5...data.count)
            
            let newData = NSString(data: data.subdata(in: r), encoding: String.Encoding.utf8.rawValue)
            
            guard let newdata = newData?.data(using: String.Encoding.utf8.rawValue) else
            {
                print("unable to convert to data")
                return
            }
            
            var parsedJsonData: NSDictionary!
            do
            {
                parsedJsonData = try JSONSerialization.jsonObject(with: newdata, options: .allowFragments) as! NSDictionary
            }
            catch
            {
                print("Unable to parse data")
                return
            }
            print(parsedJsonData)
            completionHandlerForLogOut(true,"")
    }
        task.resume()
}
    
}
