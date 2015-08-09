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
  
  private dynamic var minimumAge: NSNumber {
    get {
      return addShowDataSheet.minimumAge
    }
    set {
      addShowDataSheet.minimumAge = newValue
      print("minimum age set to \(self.minimumAge)")
    }
  }
  
  private dynamic var timeUnit: String {
    get {
      print("returned timeline of \(addShowDataSheet.timeUnit)")
      return addShowDataSheet.timeUnit
    }
    set {
      self.window!.makeFirstResponder(self.minAgeTextField)
      print("Timeunit set to \(newValue)")
      addShowDataSheet.timeUnit = newValue
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
    for property in Show.properties {
      self.setValue(show.valueForKey(property), forKey: property)
    }
    timeUnitsPopup.selectItemWithTitle(self.timeUnit)
  }
  
  // ====================
  // MARK: - IBActions
  // ====================
  
  @IBAction func timeUnitChanged(sender: NSPopUpButton) {
    // Seems to be a problem with binding a variable to the value of a popup, so using this way instead
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

