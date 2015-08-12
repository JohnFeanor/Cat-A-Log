//
//  AddShowWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

let LH = 0
let SH = 1


class AddShowWindowController: NSWindowController {
  
  private dynamic let timeUnits = [months, weeks]
  
  @IBOutlet weak var minAgeTextField: NSTextField!
  @IBOutlet weak var timeUnitsPopup: NSPopUpButton!
  @IBOutlet weak var nameTextField: NSTextField!
  
  var addShowDataSheet = AddShowDataSheet()
  
  private dynamic var affiliation: String {
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
  
  private dynamic var minimumMonths: NSNumber {
    get {
      return addShowDataSheet.minimumMonths
    }
    set {
      addShowDataSheet.minimumMonths = newValue
      if addShowDataSheet.minimumMonths.integerValue > 0 {
        self.timeUnit = months
      }
    }
  }
  
  private dynamic var minimumWeeks: NSNumber {
    get {
      return addShowDataSheet.minimumWeeks
    }
    set {
      addShowDataSheet.minimumWeeks = newValue
      if addShowDataSheet.minimumMonths.integerValue > 0 {
        self.timeUnit = weeks
      }
    }
  }
 
  private dynamic var minimumAge: NSNumber {
    get {
      if self.timeUnit == months {
        return addShowDataSheet.minimumMonths
      } else {
        return addShowDataSheet.minimumWeeks
      }
    }
    set {
      if self.timeUnit == months {
        addShowDataSheet.minimumMonths = newValue
      } else {
        addShowDataSheet.minimumWeeks = newValue
      }
    }
  }
  
  private dynamic var timeUnit: String = months {
    willSet {
      self.window!.makeFirstResponder(self.minAgeTextField)
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
  
  
  override var windowNibName: String {
    return "AddShowWindowController"
  }
  
  // ====================
  // MARK: - Methods
  // ====================
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  func setToShow(show show: Show) {
    print("Setting to show \(show)")
    print("Properties are: \(Show.properties)\n")
    for property in Show.properties {
      print("  setting \(property)")
      self.setValue(show.valueForKey(property), forKey: property)
    }
    timeUnitsPopup.selectItemWithTitle(self.timeUnit)
    self.window!.makeFirstResponder(self.nameTextField)
  }
  
  // ====================
  // MARK: - IBActions
  // ====================
  
  @IBAction func timeUnitChanged(sender: NSPopUpButton) {
    // Seems to be a problem with binding a variable to the value of a popup, so using this way instead
    print("Starting to change time unit")
    let newValue = sender.titleOfSelectedItem
    self.timeUnit = newValue ?? months
  }

  
  @IBAction func okButtonPressed(sender: NSButton) {
    window?.endEditingFor(nil)
    print("dismissing sheet with OK response\n*****")
    dismissWithModalResponse(NSModalResponseOK)
  }
  
  
  @IBAction func cancelButtonPressed(sender: NSButton) {
    print("dismissing sheet with cancel response\n****")
    dismissWithModalResponse(NSModalResponseCancel)
  }
  
  func dismissWithModalResponse(response: NSModalResponse)
  {
    window!.sheetParent!.endSheet(window!, returnCode: response)
  }
}

