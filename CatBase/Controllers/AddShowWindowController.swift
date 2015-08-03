//
//  AddShowWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

class AddShowWindowController: NSWindowController {
  
  @IBOutlet weak var timeUnitsPopup: NSPopUpButton!
  
  dynamic let sectionNames = Breeds.sectionNames
  
  private dynamic var affiliation       = NSNumber(integer: 0)
  private dynamic var date              = NSDate()
  private dynamic var judgeLH1: String  = ""
  private dynamic var judgeLH2: String  = ""
  private dynamic var judgeLH3: String  = ""
  private dynamic var judgeLH4: String  = ""
  private dynamic var judgeLH5: String  = ""
  private dynamic var judgeLH6: String  = ""
  private dynamic var judgeSH1: String  = ""
  private dynamic var judgeSH2: String  = ""
  private dynamic var judgeSH3: String  = ""
  private dynamic var judgeSH4: String  = ""
  private dynamic var judgeSH5: String  = ""
  private dynamic var judgeSH6: String  = ""
  private dynamic var minimumAgeMonths  = NSNumber(integer: 4)
  private dynamic var minimumAgeWeeks   = NSNumber(integer: 13)
  private dynamic var minimumAge        = NSNumber(integer: 4)
  private dynamic var name: String      = "New Show"
  private dynamic var numberOfRings     = NSNumber(integer: 3)
  
  private dynamic let timeUnits = ["Months", "Weeks"]

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
    self.setValuesForKeysWithDictionary(data as [NSObject : AnyObject])
  }
  
  @IBAction func okButtonPressed(sender: NSButton) {
    if timeUnitsPopup.integerValue == 0 {
      self.minimumAgeMonths = self.minimumAge
      self.minimumAgeWeeks = NSNumber(integer: 0)
    } else {
      self.minimumAgeWeeks = self.minimumAge
      self.minimumAgeMonths = NSNumber(integer: 0)
    }
    window?.endEditingFor(nil)
    println("dismissing sheet with OK response")
    println("Section list is \(self.sectionNames)")
    dismissWithModalResponse(NSModalResponseOK)
  }
  
  
  @IBAction func cancelButtonPressed(sender: NSButton) {
    println("dismissing sheet with cancel response")
    println("Section list is \(self.sectionNames)")
    dismissWithModalResponse(NSModalResponseCancel)
  }
  
  func dismissWithModalResponse(response: NSModalResponse)
  {
    window!.sheetParent!.endSheet(window!, returnCode: response)
  }

}
