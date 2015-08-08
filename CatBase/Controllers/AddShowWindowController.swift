//
//  AddShowWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

struct AddShowDataSheet {
  var affiliation   = NSNumber(integer: 0)
  var date          = NSDate()
  var judges        = [["", "", "", "", "", ""], ["", "", "", "", "", ""]]
  var minimumAge    = ["months" : NSNumber(integer: 4), "weeks" : NSNumber(integer: 13)]
  var name: String  = "New Show"
  var numberOfRings = NSNumber(integer: 3)
}

let LH = 0
let SH = 1
private let months = "Months"
private let weeks = "Weeks"


class AddShowWindowController: NSWindowController {
  
  private dynamic var timeUnit = months
  private dynamic let timeUnits = [months, weeks]
  
  @IBOutlet weak var timeUnitsPopup: NSPopUpButton!
  
  var addShowDataSheet = AddShowDataSheet()
  
  private dynamic var affiliation: NSNumber {
    get {
      return addShowDataSheet.affiliation
    }
    set {
      addShowDataSheet.affiliation = newValue
    }
  }
  
  private dynamic var date: NSDate {
    get {
      return addShowDataSheet.date
    }
    set {
      addShowDataSheet.date = newValue
    }
  }
  
  private dynamic var judgeLH1: String {
    get {
      return addShowDataSheet.judges[LH][0]
    }
    set {
      addShowDataSheet.judges[LH][0] = newValue
    }
  }
  
  private dynamic var judgeLH2: String {
    get {
      return addShowDataSheet.judges[LH][1]
    }
    set {
      addShowDataSheet.judges[LH][1] = newValue
    }
  }
  
  private dynamic var judgeLH3: String {
    get {
      return addShowDataSheet.judges[LH][2]
    }
    set {
      addShowDataSheet.judges[LH][2] = newValue
    }
  }
  
  private dynamic var judgeLH4: String {
    get {
      return addShowDataSheet.judges[LH][3]
    }
    set {
      addShowDataSheet.judges[LH][3] = newValue
    }
  }
  
  private dynamic var judgeLH5: String {
    get {
      return addShowDataSheet.judges[LH][4]
    }
    set {
      addShowDataSheet.judges[LH][4] = newValue
    }
  }
  
  private dynamic var judgeLH6: String {
    get {
      return addShowDataSheet.judges[LH][5]
    }
    set {
      addShowDataSheet.judges[LH][5] = newValue
    }
  }
  
  private dynamic var judgeSH1: String {
    get {
      return addShowDataSheet.judges[SH][0]
    }
    set {
      addShowDataSheet.judges[SH][0] = newValue
    }
  }
  
  private dynamic var judgeSH2: String {
    get {
      return addShowDataSheet.judges[SH][1]
    }
    set {
      addShowDataSheet.judges[SH][1] = newValue
    }
  }
  
  private dynamic var judgeSH3: String {
    get {
      return addShowDataSheet.judges[SH][2]
    }
    set {
      addShowDataSheet.judges[SH][2] = newValue
    }
  }
  
  private dynamic var judgeSH4: String {
    get {
      return addShowDataSheet.judges[SH][3]
    }
    set {
      addShowDataSheet.judges[SH][3] = newValue
    }
  }
  
  private dynamic var judgeSH5: String {
    get {
      return addShowDataSheet.judges[SH][4]
    }
    set {
      addShowDataSheet.judges[SH][4] = newValue
    }
  }
  
  private dynamic var judgeSH6: String {
    get {
      return addShowDataSheet.judges[SH][5]
    }
    set {
      addShowDataSheet.judges[SH][5] = newValue
    }
  }
  
  private dynamic var minimumAgeMonths: NSNumber {
    get {
      return addShowDataSheet.minimumAge[months]!
    }
    set {
      addShowDataSheet.minimumAge[months] = newValue
    }
  }
  
  private dynamic var minimumAgeWeeks: NSNumber {
    get {
      return addShowDataSheet.minimumAge[weeks]!
    }
    set {
      addShowDataSheet.minimumAge[weeks] = newValue
    }
  }
  
  private dynamic var name: String {
    get {
      return addShowDataSheet.name
    }
    set {
      addShowDataSheet.name = newValue
    }
  }
  
  private dynamic var numberOfRings: NSNumber {
    get {
      return addShowDataSheet.numberOfRings
    }
    set {
      addShowDataSheet.numberOfRings = newValue
    }
  }
  
  private var minimumAge = NSNumber(integer: 4)
  
  var asDictionary: NSDictionary {
    get {
      return NSDictionary(objects: [affiliation, date, judgeLH1, judgeLH2, judgeLH3, judgeLH4, judgeLH5, judgeLH6, judgeSH1, judgeSH2, judgeSH3, judgeSH4, judgeSH5, judgeSH6, minimumAgeMonths, minimumAgeWeeks, name, numberOfRings], forKeys: Show.properties)
    }
  }
  
  override var windowNibName: String {
    return "AddShowWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  func setDataTo(data: NSDictionary) {
    self.setValuesForKeysWithDictionary(data as! [String : AnyObject])
  }
  
  @IBAction func okButtonPressed(sender: NSButton) {
    if timeUnit == months {
      self.minimumAgeMonths = self.minimumAge
      self.minimumAgeWeeks = NSNumber(integer: 0)
    } else {
      self.minimumAgeWeeks = self.minimumAge
      self.minimumAgeMonths = NSNumber(integer: 0)
    }
    window?.endEditingFor(nil)
    print("dismissing sheet with OK response")
    dismissWithModalResponse(NSModalResponseOK)
  }
  
  
  @IBAction func cancelButtonPressed(sender: NSButton) {
    print("dismissing sheet with cancel response")
    dismissWithModalResponse(NSModalResponseCancel)
  }
  
  func dismissWithModalResponse(response: NSModalResponse)
  {
    window!.sheetParent!.endSheet(window!, returnCode: response)
  }
}

