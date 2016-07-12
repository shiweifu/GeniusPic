//
//  Ext.swift
//  GeniusPic
//
//  Created by shiweifu on 16/7/10.
//  Copyright © 2016年 shiweifu. All rights reserved.
//

import Cocoa

extension NSApplication {
  
  func uploadImage(img: NSImage) -> Void {
  }
  
  static func writeToPasteboard(str: String) -> Void {

    let pasteboard = NSPasteboard.generalPasteboard()
    pasteboard.clearContents()
    pasteboard.writeObjects([str])
    
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
