//
//  DPRequest.swift
//  GeniusPic
//
//  Created by shiweifu on 16/7/10.
//  Copyright © 2016年 shiweifu. All rights reserved.
//

import Cocoa


typealias DPRCallback = (AnyObject) -> Void
typealias HTTPSessionCallback = (NSData?, NSURLResponse?, NSError?) -> Void

enum DPRequestMethod: String {
  case GET = "GET"
  case POST = "POST"
}

enum DPRequestParseType {
  case JSON
  case STRING
}

class DPRequest: NSObject {
  
  var postData: NSData?
  var url:      String
  var method:   DPRequestMethod
  var callback: DPRCallback
  
  var httpHeaders:[String:String] = [:]
  let parseType: DPRequestParseType
  
  init(url: String, method: DPRequestMethod, parseType: DPRequestParseType, callback: DPRCallback ) {
    self.url = url
    self.method = method
    self.callback = callback
    self.parseType = parseType
  }
  
  func prepareRequest() -> NSURLRequest {
    let req = NSURLRequest()
    return req
  }
  
  func startAsync() -> Void {
    
    let url = NSURL(string: self.url)!
    
    let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session              = NSURLSession(configuration: sessionConfiguration)
    let req                  = NSMutableURLRequest(URL: url)
    req.HTTPMethod           = self.method.rawValue
    
    if (self.postData != nil) {
      req.HTTPBody = self.postData
    }
    
    for(k, v) in self.httpHeaders {
      req.addValue(v, forHTTPHeaderField: k)
    }
    
    let sessionCallback: HTTPSessionCallback = {(data: NSData?, resp: NSURLResponse?, err: NSError?) -> Void in
      
      if(self.parseType == .JSON) {
        
        do {
         let jsonObj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
         self.callback(jsonObj as! NSDictionary)
        }
        
        catch { }
      }
      else if(self.parseType == .STRING) {
        let strObj = NSString(data: data!, encoding: NSUTF8StringEncoding)
        self.callback(strObj!)
      }
    }
    
    let task: NSURLSessionDataTask = session.dataTaskWithRequest(req, completionHandler: sessionCallback)
    
    task.resume()
  }
  
  
  func addCookie(cookie: NSHTTPCookie) {
    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie)
  }
  
  
  class func createCookieWithName(name: String, value: String, url: NSURL) -> NSHTTPCookie {
    let cookieProperties: [String : AnyObject] = [
      NSHTTPCookieName : name,
      NSHTTPCookieValue : value,
      NSHTTPCookieOriginURL : url,
      NSHTTPCookieDiscard : "FALSE",
      NSHTTPCookiePath : "/",
      NSHTTPCookieVersion : "0",
      NSHTTPCookieExpires : NSDate().dateByAddingTimeInterval(3600 * 24 * 30)
    ]
    
    let cookie: NSHTTPCookie = NSHTTPCookie(properties: cookieProperties)!
    return cookie
  }
  
  
  func addCookieWithName(name: String, value: String, url: NSURL) {
    let cookie: NSHTTPCookie = DPRequest.createCookieWithName(name, value: value, url: url)
    self.addCookie(cookie)
  }
}
