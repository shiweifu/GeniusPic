//
//  Ext.swift
//  GeniusPic
//
//  Created by shiweifu on 16/7/10.
//  Copyright © 2016年 shiweifu. All rights reserved.
//

import Cocoa

extension NSApplication {
  
  static func base64(data: NSData) -> String {
    return data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
  }
  
  func uploadImage(img: NSImage) -> Void {
  }
}

extension NSImage {
  func base64() -> NSString {
    let data = self.TIFFRepresentation
    return NSApplication.base64(data!)
  }
}

extension String {
  func utf8_data() -> NSData? {
    return self.dataUsingEncoding(NSUTF8StringEncoding)
  }
}


