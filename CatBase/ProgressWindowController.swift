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
  
  override var windowNibName: String {
    return "ProgressWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
  }
  
  var progressBarSize: Double = 100.0
  
  func incrementProgress() {
    progressBar.incrementBy(100.0 / progressBarSize)
    progressBar.displayIfNeeded()
  }
  
  func  setProgress(newValue: Double) {
    let percentage = 100.0 / progressBarSize * newValue
    progressBar.doubleValue = percentage > 100.0 ? 100.0 : percentage
    progressBar.displayIfNeeded()
  }
  
}
