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
    
    func generateName(callback: (String?, ErrorType?) -> ()) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, err) in
            do {
                if let json = data {
                    if let jsonObject = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, AnyObject>, let name = jsonObject["name"] as? String {
                        self.doCallbackOnMainThread(name, error: nil, callback: callback)
                    } else {
                        self.doCallbackOnMainThread(nil, error: NSError(domain: "JSONParsing", code: 0, userInfo: ["JsonData": json]), callback: callback)
                    }
                } else {
                    self.doCallbackOnMainThread(nil, error: err, callback: callback)
                }
            } catch {
                self.doCallbackOnMainThread(nil, error: error, callback: callback)
            }
            
        }

        task.resume()
    }
    
    private func doCallbackOnMainThread(result:String?, error:ErrorType?, callback:(String?, ErrorType?) -> ()) {
        dispatch_async(dispatch_get_main_queue()) {
            callback(result, error)
        }
    }
}