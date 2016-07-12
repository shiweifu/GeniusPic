//
//  AppDelegate.swift
//  GeniusPic
//
//  Created by shiweifu on 16/7/10.
//  Copyright © 2016年 shiweifu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  var masterViewController: MasterViewController!

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // Insert code here to initialize your application
    masterViewController = MasterViewController(nibName: "MasterViewController", bundle: nil)
    window.contentView?.addSubview(masterViewController.view)
    masterViewController.view.frame = (window.contentView! as NSView).bounds
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }


}

