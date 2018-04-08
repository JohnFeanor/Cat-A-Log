//
//  ProgressWindowController.swift
//  Cat-A-Log
//
//  Created by John Sandercock on 23/09/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa


class ProgressWindowController: NSWindowController {
  
  @IBOutlet weak var progressBar: NSProgressIndicator!
  
  @objc dynamic var progressLabel = "Updating cats"
  @objc dynamic var progressValue = 100.0
  
  fileprivate var masterWindow: NSWindow? = nil
  
  override var windowNibName: NSNib.Name? {
    return NSNib.Name("ProgressWindowController")
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
  }
  
  @objc var progressBarSize: Double = 100.0
  
  @objc func incrementProgress() {
    progressValue += 1.0
  }
  
  @objc func beginCountDown(onWindow master: NSWindow, withLabel label: String? = nil) {
    progressValue = 0.0
    if label != nil {
      self.progressLabel = label!
    }
    masterWindow = master
    master.beginSheet(self.window!) { response in
    }
    if progressBar != nil {
      progressBar.startAnimation(self)
    } else {
      print("Progress Bar is nil")
    }
  }
  
  @objc func endCountDown() {
    if progressBar != nil {
      progressBar.stopAnimation(self)
    }
    if masterWindow != nil  {
      masterWindow?.endSheet(self.window!)
       masterWindow = nil
    }
  }
  
}
