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

  @objc fileprivate dynamic let timeUnits = ["Months", "Weeks"]
  
  @objc var showData: [String : AnyObject]  {
    return self.dictionaryWithValues(forKeys: Show.properties) as [String : AnyObject]
  }
  
  override var windowNibName: NSNib.Name? {
    return NSNib.Name("AddShowWindowController")
  }
  
  // MARK: - show properties
  
  @objc fileprivate dynamic var affiliation: String = "QFA Show"
  @objc fileprivate dynamic var name: String = "New Show"
  
  @objc fileprivate dynamic var date: Date = Date()
  
  @objc fileprivate dynamic var judgeLH1: String = ""
  @objc fileprivate dynamic var judgeLH2: String = ""
  @objc fileprivate dynamic var judgeLH3: String = ""
  @objc fileprivate dynamic var judgeLH4: String = ""
  @objc fileprivate dynamic var judgeLH5: String = ""
  @objc fileprivate dynamic var judgeLH6: String = ""
  
  @objc fileprivate dynamic var judgeSH1: String = ""
  @objc fileprivate dynamic var judgeSH2: String = ""
  @objc fileprivate dynamic var judgeSH3: String = ""
  @objc fileprivate dynamic var judgeSH4: String = ""
  @objc fileprivate dynamic var judgeSH5: String = ""
  @objc fileprivate dynamic var judgeSH6: String = ""
  
  @objc fileprivate dynamic var numberOfRings: NSNumber = three
 
  @objc fileprivate dynamic var minimumAge: NSNumber = three
  
  
  // MARK: - Variables for the entry sheet not part of a show
  
  @objc fileprivate dynamic var timeUnit: Int = months  {
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
  
  @objc func setToShow(show: Show) {
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

    dismissWithModalResponse(NSApplication.ModalResponse.OK)
  }
  
  
  @IBAction func cancelButtonPressed(_ sender: NSButton) {
    dismissWithModalResponse(NSApplication.ModalResponse.cancel)
  }
  
  @objc func dismissWithModalResponse(_ response: NSApplication.ModalResponse)
  {
    window!.sheetParent!.endSheet(window!, returnCode: response)
  }
}

