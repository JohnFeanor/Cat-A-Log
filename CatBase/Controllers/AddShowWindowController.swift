//
//  AddShowWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

private let zero = NSNumber(value: 0 as Int)
private let three = NSNumber(value: 3 as Int)

private let months = 0
private let weeks = 1


class AddShowWindowController: NSWindowController {
  
  @IBOutlet weak var minAgeTextField: NSTextField!
  @IBOutlet weak var nameTextField: NSTextField!

  fileprivate dynamic let timeUnits = ["Months", "Weeks"]
  
  var showData: [String : AnyObject]  {
    return self.dictionaryWithValues(forKeys: Show.properties) as [String : AnyObject]
  }
  
  override var windowNibName: String {
    return "AddShowWindowController"
  }
  
  // MARK: - show properties
  
  fileprivate dynamic var affiliation: String = "QFA Show"
  fileprivate dynamic var name: String = "New Show"
  
  fileprivate dynamic var date: Date = Date()
  
  fileprivate dynamic var judgeLH1: String = ""
  fileprivate dynamic var judgeLH2: String = ""
  fileprivate dynamic var judgeLH3: String = ""
  fileprivate dynamic var judgeLH4: String = ""
  fileprivate dynamic var judgeLH5: String = ""
  fileprivate dynamic var judgeLH6: String = ""
  
  fileprivate dynamic var judgeSH1: String = ""
  fileprivate dynamic var judgeSH2: String = ""
  fileprivate dynamic var judgeSH3: String = ""
  fileprivate dynamic var judgeSH4: String = ""
  fileprivate dynamic var judgeSH5: String = ""
  fileprivate dynamic var judgeSH6: String = ""
  
  fileprivate dynamic var numberOfRings: NSNumber = three
 
  fileprivate dynamic var minimumAge: NSNumber = three
  
  
  // MARK: - Variables for the entry sheet not part of a show
  
  fileprivate dynamic var timeUnit: Int = months  {
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
  
  func setToShow(show: Show) {
    for property in Show.properties {
      self.setValue(show.value(forKey: property), forKey: property)
    }
    self.window!.makeFirstResponder(self.nameTextField)
  }
  
  // ====================
  // MARK: - IBActions
  // ====================

  
  @IBAction func okButtonPressed(_ sender: NSButton) {
    window?.endEditing(for: nil)

    dismissWithModalResponse(NSModalResponseOK)
  }
  
  
  @IBAction func cancelButtonPressed(_ sender: NSButton) {
    dismissWithModalResponse(NSModalResponseCancel)
  }
  
  func dismissWithModalResponse(_ response: NSModalResponse)
  {
    window!.sheetParent!.endSheet(window!, returnCode: response)
  }
}

