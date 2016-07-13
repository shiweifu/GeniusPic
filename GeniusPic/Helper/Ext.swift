//
//  Ext.swift
//  GeniusPic
//
//  Created by shiweifu on 16/7/10.
//  Copyright © 2016年 shiweifu. All rights reserved.
//

import Cocoa

typealias UploadSucessCallback = (String, NSError?) -> Void

extension NSApplication {
  
  static func uploadImage(img: NSImage, callback: UploadSucessCallback) -> Void {
   
    let setting = NSApplication.readPlistWithResource("Setting")
    
    let leanCloudID  = setting!["LeanCloudID"]!
    let leanCloudKey = setting!["LeanCloudKey"]!
    
    let jsonCallback: DPRCallback = {(obj) in
      print(obj)
      
      if let url = obj["url"] {
        callback(url as! String, nil)
      }
      else {
        let err = NSError(domain: "leanCloud", code: 0, userInfo: ["errMsg": "上传失败"])
        callback("", err)
      }
    }
    
    let img = img
    
    let url = "https://api.leancloud.cn/1.1/files/hp.jpg"
    
    let req = DPRequest(url:url, method: .POST, parseType: .JSON, callback:jsonCallback)
    req.httpHeaders["Content-Type"] = "image/jpeg"
    req.httpHeaders["X-LC-Id"]  = leanCloudID
    req.httpHeaders["X-LC-Key"] = leanCloudKey
    
    req.postData = img.imageJPEGRepresentation
    req.startAsync()
    
    
  }
  
  static func writeToPasteboard(str: String) -> Void {

    let pasteboard = NSPasteboard.generalPasteboard()
    pasteboard.clearContents()
    pasteboard.writeObjects([str])
    
  }
  
  static func readPlistWithResource(name: String) -> [String:String]? {
    let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist")
    
    guard let settingPath = path else {
      return nil
    }
   
    let result = NSDictionary(contentsOfFile: settingPath)
    return result as? [String: String]
  }
  
  static func alertInfo(str: String) -> Void {
    let alert = NSAlert()
    alert.informativeText = str
    alert.runModal()
  }
}

extension NSData {
  func base64() -> NSData {
    return self.base64EncodedDataWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
  }
}

extension NSImage {
  
  func PNGRepresentationOfImage() -> NSData {
    // Create a bitmap representation from the current image
    let image = self
    image.lockFocus()
    let bitmapRep: NSBitmapImageRep? = NSBitmapImageRep(focusedViewRect: NSMakeRect(0, 0, image.size.width, image.size.height))
    image.unlockFocus()
    let result = bitmapRep!.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: [:])!
    return result
  }
  
  
  var imageJPEGRepresentation: NSData {
    return NSBitmapImageRep(data: TIFFRepresentation!)!.representationUsingType(.NSJPEGFileType, properties: [:])!
  }
  
  func base64() -> NSData {
    let data = self.PNGRepresentationOfImage()
    return data.base64()
  }
}

extension String {
  func utf8_data() -> NSData? {
    return self.dataUsingEncoding(NSUTF8StringEncoding)
  }
}
