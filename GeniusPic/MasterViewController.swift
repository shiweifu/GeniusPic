//
//  MasterViewController.swift
//  BugScary
//
//  Created by shiweifu on 16/7/11.
//  Copyright © 2016年 shiweifu. All rights reserved.
//

import Cocoa

let MARKDOWN_FMT = "![]({URL})"

class MasterViewController: NSViewController {

  @IBOutlet weak var imgView: NSImageView!
  @IBOutlet weak var btnCustom: NSButton!
  @IBOutlet weak var btnMarkdown: NSButton!
  
  @IBOutlet weak var imageUrlTextField: NSTextField!
  @IBOutlet weak var customFormatTextField: NSTextField!
  
  var image: NSImage?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
      
      let imgClickGesture = NSClickGestureRecognizer()
      imgClickGesture.action = #selector(onSelectImage)
      imgClickGesture.target = self
      imgClickGesture.numberOfClicksRequired = 1
      imgClickGesture.buttonMask = 0x01
      self.imgView.addGestureRecognizer(imgClickGesture)
    }
  
  func prepare() -> Void {
    self.imageUrlTextField.stringValue = ""
  }
    
  @IBAction func onUpload(sender: AnyObject) {
    
    if(self.image == nil) {
      NSApplication.alertInfo("请先选择图片")
      return
    }
    
    let uploadCallback = {(url:String, err:NSError?) in
      
      if let err = err {
        NSApplication.alertInfo(err.userInfo["errMsg"] as! String)
        return
      }
     
      self.imageUrlTextField.stringValue = url
      self.imageUrlTextField.placeholderString = "图片URL"
    }
   
    NSApplication.uploadImage(self.image!, callback: uploadCallback)
    
    self.imageUrlTextField.placeholderString = "正在上传……"

  }
  
  @IBAction func onCopyURL(sender: AnyObject) {
    let url = self.imageUrlTextField.stringValue as String
    NSApplication.writeToPasteboard(url)
  }
  
  
  @IBAction func onCopyForMarkdown(sender: AnyObject) {
    let fmt = MARKDOWN_FMT
    let url = self.imageUrlTextField.stringValue as String
    let str = fmt.stringByReplacingOccurrencesOfString("{URL}", withString: url)
    NSApplication.writeToPasteboard(str)
  }
  
  @IBAction func onCopyForCustom(sender: AnyObject) {
    let fmt = self.customFormatTextField.stringValue
    let url = self.imageUrlTextField.stringValue as String
    let str = fmt.stringByReplacingOccurrencesOfString("{URL}", withString: url)
    NSApplication.writeToPasteboard(str)
  }
  
  func onSelectImage() {
    let openPanel = NSOpenPanel()
    openPanel.directoryURL = NSURL(string: NSHomeDirectory())
    openPanel.allowedFileTypes = ["jpg", "jpeg", "png"]
    openPanel.beginWithCompletionHandler { (resultCode) in
      if(resultCode == NSModalResponseOK) {
        let url = openPanel.URL!
        self.loadImage(url)
      }
    }
  }
  
// Utils
  
  func loadImage(url: NSURL) -> Void {
    self.image = NSImage(contentsOfURL: url)
    self.imgView.image = self.image
    self.prepare()
  }
}
