//
//  OnlineNameGenerator.swift
//  ReliantFramework Example
//
//  Created by Michael Seghers on 15/01/16.
//  Copyright © 2016 AppFoundry. All rights reserved.
//

import Foundation

struct OnlineNameGenerator : NameGenerator {
    let queue:NSOperationQueue = NSOperationQueue()
    let url = NSURL(string: "http://api.uinames.com/?region=United%20States")!
    
    func generateName(callback: (String) -> ()) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, err) in
            do {
                if let json = data {
                    if let jsonObject = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, AnyObject>, let name = jsonObject["name"] as? String {
                        dispatch_async(dispatch_get_main_queue()) {
                            callback(name)
                        }
                    } else {
                        print("Problems parsing json: \(json)")
                    }
                } else {
                    print("No data!, error maybe? \(err)")
                }
            } catch {
                print("Could not generate name: \(error)")
            }
            
        }

        task.resume()


        
    }
}