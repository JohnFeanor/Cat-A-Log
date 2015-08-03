//
//  EntrySheetController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

class EntrySheetController: NSWindowController {
  
  private dynamic var registration        = "Pending"
  private dynamic var title               = ""
  private dynamic var name                = ""
  private dynamic var breed               = ""
  private dynamic var colour              = ""
  private dynamic var sex                 = ""
  private dynamic var challenge           = ""
  private dynamic var birthDate           = NSDate()
  private dynamic var sire                = ""
  private dynamic var dam                 = ""
  private dynamic var breeder             = ""
  private dynamic var exhibitor           = ""

  private dynamic var cageType            = NSNumber(integer: 0)
  private dynamic var cageSize            = NSNumber(integer: 110)
  private dynamic var hireCage            = NSNumber(bool: false)
  private dynamic var litter              = NSNumber(bool: false)

  private dynamic var ring1               = NSNumber(bool: true)
  private dynamic var ring2               = NSNumber(bool: true)
  private dynamic var ring3               = NSNumber(bool: true)
  private dynamic var ring4               = NSNumber(bool: false)
  private dynamic var ring5               = NSNumber(bool: false)
  private dynamic var ring6               = NSNumber(bool: false)
  private dynamic var willWork            = NSNumber(bool: false)
  private dynamic var catalogueRequired   = NSNumber(bool: false)
  private dynamic var vaccinated          = NSNumber(bool: false)
  private dynamic var cat                 = NSNumber(bool: false)
  private dynamic var toBeDeleted         = NSNumber(bool: false)

  @IBOutlet var allCapsFormatter: AllCapsFormatter!
  @IBOutlet var nameFormatter: NameFormatter!
  
  // MARK: - hooks to the textfields
  
  @IBOutlet weak var registrationTextField: NSTextField!
  @IBOutlet weak var titleComboBox: NSComboBox!
  @IBOutlet weak var nameTextField: NSTextField!
  @IBOutlet weak var breedComboBox: NSComboBox!
  @IBOutlet weak var colourComboBox: NSComboBox!
  @IBOutlet weak var sexComboBox: NSComboBox!
  @IBOutlet weak var challengeComboBox: NSComboBox!
  @IBOutlet weak var birthDatePicker: NSDatePicker!
  @IBOutlet weak var sireTextField: NSTextField!
  @IBOutlet weak var damTextField: NSTextField!
  @IBOutlet weak var breederTextField: NSTextField!
  @IBOutlet weak var exhibitorTextField: NSTextField!
  
  override var windowNibName: String {
    return "EntrySheetController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  @IBAction func okButtonPressed(sender: NSButton) {
    window?.endEditingFor(nil)
    println("dismissing entry sheet with OK response")
    dismissWithModalResponse(NSModalResponseOK)
  }
  
  @IBAction func cancelButtonPressed(sender: NSButton) {
    println("dismissing entry sheet with cancel response")
    dismissWithModalResponse(NSModalResponseCancel)
  }
  
  func dismissWithModalResponse(response: NSModalResponse)
  {
    window!.sheetParent!.endSheet(window!, returnCode: response)
  }
 
}
