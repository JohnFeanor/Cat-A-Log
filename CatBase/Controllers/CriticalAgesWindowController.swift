//
//  criticalAgesWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 20/09/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class CriticalAgesWindowController: NSWindowController {
  
    override var windowNibName: String {
    return "CriticalAgesWindowController"
  }

  dynamic var showAgeMinWeeks: Int {
    get {
      return Globals.minShowAge.weeks
    }
    set {
      Globals.setMinShowAge(weeks: newValue)
    }
  }
  
  dynamic var showAgeMinMonths: Int {
    get {
      return Globals.minShowAge.months
    }
    set {
      Globals.setMinShowAge(months: newValue)
    }
  }
  
  dynamic var litterAgeMinWeeks: Int {
    get {
      return Globals.maxLitterAge.weeks
    }
    set {
      Globals.setMaxLitterAge(weeks: newValue)
    }
  }
  
  dynamic var litterAgeMinMonths: Int {
    get {
      return Globals.maxLitterAge.months
    }
    set {
      Globals.setMaxLitterAge(months: newValue)
    }
  }
  
  dynamic var maxPendingAgeWeeks: Int {
    get {
      return Globals.maxPendingAge.weeks
    }
    set {
      Globals.setMaxPendingAge(weeks: newValue)
    }
  }
  
  dynamic var maxPendingAgeMonths: Int {
    get {
      return Globals.maxPendingAge.months
    }
    set {
      Globals.setMaxPendingAge(months: newValue)
    }
  }
  
  dynamic var kittenAgeMax: Int {
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
