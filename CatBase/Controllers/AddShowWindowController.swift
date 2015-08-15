//
//  AddShowWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

private let zero = NSNumber(integer: 0)
private let three = NSNumber(integer: 3)

private let months = 0
private let weeks = 1


class AddShowWindowController: NSWindowController {
  
  @IBOutlet weak var minAgeTextField: NSTextField!
  @IBOutlet weak var nameTextField: NSTextField!

  private dynamic let timeUnits = ["Months", "Weeks"]
  
  var showData: [String : AnyObject]  {
    return self.dictionaryWithValuesForKeys(Show.properties)
  }
  
  override var windowNibName: String {
    return "AddShowWindowController"
  }
  
  // MARK: - show properties
  
  private dynamic var affiliation: String = "QFA Show"
  private dynamic var name: String = "New Show"
  
  private dynamic var date: NSDate = NSDate()
  
  private dynamic var judgeLH1: String = ""
  private dynamic var judgeLH2: String = ""
  private dynamic var judgeLH3: String = ""
  private dynamic var judgeLH4: String = ""
  private dynamic var judgeLH5: String = ""
  private dynamic var judgeLH6: String = ""
  
  private dynamic var judgeSH1: String = ""
  private dynamic var judgeSH2: String = ""
  private dynamic var judgeSH3: String = ""
  private dynamic var judgeSH4: String = ""
  private dynamic var judgeSH5: String = ""
  private dynamic var judgeSH6: String = ""
  
  private dynamic var minimumMonths: NSNumber = three
  private dynamic var minimumWeeks: NSNumber = zero
  private dynamic var numberOfRings: NSNumber = three
 
  private dynamic var minimumAge: NSNumber = three
  
  
  // MARK: - Variables for the entry sheet not part of a show
  
  private dynamic var timeUnit: Int = months  {
    didSet {
      self.window!.makeFirstResponder(self.minAgeTextField)
    }
  }
  
  // ====================
  // MARK: - Methods
  // ====================
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  
  // initialize the sheet to an existing Show
  
  func setToShow(show show: Show) {
    for property in Show.properties {
      self.setValue(show.valueForKey(property), forKey: property)
    }
    if minimumMonths == zero {
      minimumAge = minimumWeeks
      timeUnit = weeks
    } else {
      minimumAge = minimumMonths
      timeUnit = months
    }
    self.window!.makeFirstResponder(self.nameTextField)
  }
  
  // ====================
  // MARK: - IBActions
  // ====================

  
  @IBAction func okButtonPressed(sender: NSButton) {
    window?.endEditingFor(nil)

    if timeUnit == months {
      minimumMonths = minimumAge
      minimumWeeks = zero
    } else {
      minimumWeeks = minimumAge
      minimumMonths = zero
    }
    
    dismissWithModalResponse(NSModalResponseOK)
  }
  
  
  @IBAction func cancelButtonPressed(sender: NSButton) {
    dismissWithModalResponse(NSModalResponseCancel)
  }
  
  func dismissWithModalResponse(response: NSModalResponse)
  {
    window!.sheetParent!.endSheet(window!, returnCode: response)
  }
}

