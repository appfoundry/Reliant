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
    
    
    func generateName(callback: (String?, ErrorType?) -> ()) {
        let url = NSURL(string: "http://api.uinames.com/?region=United%20States")!
        
        self.doCallToURL(url, andTransformUsing: {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData($0, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, AnyObject>
            return jsonObject.map(self.nameFromDictionary)
        }, callback: callback)
    }
    
    func nameFromDictionary(dictionary:Dictionary<String, AnyObject>) -> String {
        return (dictionary["name"] as? String) ?? "Unkown"
    }
    
    func generateNumberOfNames(number:UInt, callback: ([String]?, ErrorType?) -> ()) {
        let url = NSURL(string: "http://api.uinames.com/?region=United%20States&amount=\(number)")!
        
        self.doCallToURL(url, andTransformUsing: {
                let jsonObject = try NSJSONSerialization.JSONObjectWithData($0, options: NSJSONReadingOptions.AllowFragments) as? Array<Dictionary<String, AnyObject>>
                return jsonObject.map {
                    return $0.map(self.nameFromDictionary)
                }
            }, callback: callback);
    }
    
    func doCallToURL<ResultType>(url:NSURL, andTransformUsing dataTransformer:(NSData) throws -> ResultType?, callback:(ResultType?, ErrorType?) -> ())  {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, err) in
            do {
                if let json = data {
                    let result = try dataTransformer(json)
                    if result != nil {
                        self.doCallbackOnMainThread(result, error: nil, callback: callback)
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
    
    private func doCallbackOnMainThread<ResultType>(result:ResultType?, error:ErrorType?, callback:(ResultType?, ErrorType?) -> ()) {
        dispatch_async(dispatch_get_main_queue()) {
            callback(result, error)
        }
    }
}