//
//  criticalAgesWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 20/09/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class CriticalAgesWindowController: NSWindowController {
  
    override var windowNibName: NSNib.Name? {
    return NSNib.Name("CriticalAgesWindowController")
  }

  @objc dynamic var showAgeMinWeeks: Int {
    get {
      return Globals.minShowAge.weeks
    }
    set {
      Globals.setMinShowAge(weeks: newValue)
    }
  }
  
  @objc dynamic var showAgeMinMonths: Int {
    get {
      return Globals.minShowAge.months
    }
    set {
      Globals.setMinShowAge(months: newValue)
    }
  }
  
  @objc dynamic var litterAgeMinWeeks: Int {
    get {
      return Globals.maxLitterAge.weeks
    }
    set {
      Globals.setMaxLitterAge(weeks: newValue)
    }
  }
  
  @objc dynamic var litterAgeMinMonths: Int {
    get {
      return Globals.maxLitterAge.months
    }
    set {
      Globals.setMaxLitterAge(months: newValue)
    }
  }
  
  @objc dynamic var maxPendingAgeWeeks: Int {
    get {
      return Globals.maxPendingAge.weeks
    }
    set {
      Globals.setMaxPendingAge(weeks: newValue)
    }
  }
  
  @objc dynamic var maxPendingAgeMonths: Int {
    get {
      return Globals.maxPendingAge.months
    }
    set {
      Globals.setMaxPendingAge(months: newValue)
    }
  }
  
  @objc dynamic var kittenAgeMax: Int {
    get {
      return Globals.maxKittenAge
    }
    set {
      Globals.setMaxKittenAge(months: newValue)
    }
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
}
