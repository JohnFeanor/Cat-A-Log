//
//  EntrySheetController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

private let zero  = NSNumber(integer: 0)
private let NO    = NSNumber(bool: false)
private let YES   = NSNumber(bool: true)

import Cocoa

class EntrySheetController: NSWindowController {

// -------------------------------
  @IBOutlet weak var cageSizeTextField: NSTextField!
  @IBOutlet weak var initialTextField: NSTextField!
  
  var managedObjectContext: NSManagedObjectContext!
  
  var entryData: [String : AnyObject] {
    let properties = Entry.properties + Cat.properties
    return self.dictionaryWithValuesForKeys(properties)
  }
  
  let cageNames = Globals.cageTypes.names
  let cageSizes = Globals.cageTypes.sizes
  
  let _litterCage: Int = {
    if Globals.cageTypes.names.count > 0 {
      return Globals.cageTypes.names.count - 1
    } else {
      return 0
    }
  }()
  
  let _hireCage: Int = {
    if Globals.cageTypes.names.count > 1 {
      return Globals.cageTypes.names.count - 2
    } else {
      return 0
    }
  }()
  
  let _otherCage: Int = {
    if Globals.cageTypes.names.count > 2 {
      return Globals.cageTypes.names.count - 3
    } else {
      return 0
    }
    }()

  // MARK: - Entry sheet items
  // -------------------------
  dynamic var registration = pending {
    didSet {
      // find out if this cat is in the database
      // and fill in the details if it is
      if registration != pending && !filledFields {
        let same = fetchCatsWithRegistration(registration, inContext: self.managedObjectContext)
        setSheetTo(same.first, except: [Cat.registration])
      }
    }
  }
  dynamic var title = String()
  dynamic var name = String() {
    didSet {
      let prefixes = name.componentsSeparatedByString(" ")
      if !prefixes.isEmpty {
        if sire.isEmpty {
          sire = prefixes[0] + " "
        }
        if dam.isEmpty {
          dam = prefixes[0] + " "
        }
      }
      if !filledFields {
        let same = fetchCatsWithName(self.name, inContext: self.managedObjectContext)
        let cat = same.first
        setSheetTo(cat, except: [Cat.registration, Cat.name])
        let noRego = registration.isEmpty || registration == pending
        if noRego && cat != nil {
          registration = cat!.registration
        }
      }
    }
  }
  
  dynamic var breed     = String()
  dynamic var colour    = String()
  dynamic var sex       = String()
  dynamic var challenge = String()
  dynamic var birthDate = NSDate()
  dynamic var sire      = String()
  dynamic var dam       = String()
  dynamic var exhibitor = String()
  dynamic var breeder   = String() {
    didSet {
      if self.exhibitor.isEmpty {
        self.exhibitor = breeder
      }
    }
  }
  
  dynamic var cageType = zero {
    didSet {
      let cageInt = cageType.integerValue
      cageSize = Globals.cageTypes.sizes[cageInt]
      if cageInt == _otherCage {
        enableCageSizeTextField = true
        self.window?.makeFirstResponder(self.cageSizeTextField)
      } else {
        enableCageSizeTextField = false
        if oldValue == _otherCage {
          self.window?.makeFirstResponder(initialTextField)
        }
      }
      litterCage = (cageInt == _litterCage)
      hireCage = (cageInt == _hireCage)
    }
  }
  dynamic var cageSize = NSNumber(integer: Globals.cageTypes.sizes[0])
  
  dynamic var hireCage    = false
  dynamic var litterCage  = false
  
  dynamic var ring1 = true
  dynamic var ring2 = true
  dynamic var ring3 = true
  dynamic var ring4 = false
  dynamic var ring5 = false
  dynamic var ring6 = false
  
  dynamic var willWork = false
  dynamic var catalogueRequired = false
  dynamic var vaccinated = false
  
  // MARK: - Other variables for sheet
  // ---------------------------------
  dynamic var enableCageSizeTextField = false
  var filledFields = false

  // ****************
  // MARK: - Methods
  // ****************
  
  @IBAction func cageSizeMenuChosen(sender: NSPopUpButton) {
    // not doing anything, just ensuring this class is the target of the popup
  }
  
  override var windowNibName: String {
    return "EntrySheetController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  
  // Litter cage type not selectable unless the entry is a kitten
  // -------------------------------------------------------------
  override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
    let selector = menuItem.action
    let tag = menuItem.tag
    if (tag == _litterCage) && (selector == Selector("cageSizeMenuChosen:")) {
      return Challenges.isAKitten(self.challenge)
    } else {
      return true
    }
  }
  
  // ***********************
  // MARK: - Helper Methods
  // ***********************
    
  // Helper methods to copy items from an existing Cat or Entry
  // ----------------------------------------------------------
  func setSheetTo(original: Cat?, except exceptions: [String]?) {
    if let original = original {
      let properties: [String]
      if exceptions == nil {
        properties = Cat.properties
      } else {
        properties = Cat.properties.filter { !exceptions!.contains($0) }
      }
      for key in properties {
        self.setValue(original.valueForKey(key), forKey: key)
      }
      filledFields = true
    }
  }
  
  func setSheetTo(original: Entry) {
    for key in Cat.properties {
      self.setValue(original.cat.valueForKey(key), forKey: key)
    }
    for key in Entry.properties {
      self.setValue(original.valueForKey(key), forKey: key)
    }
  }
  


  // =============================================
  // MARK: - Ensure all data needed is in and OK
  // =============================================

  // list of the fields that must be filled in correctly
  // ----------------------------------------------------
  private let possibleFaults = ["registration", "name", "breed", "colour", "sex", "challenge", "sire", "dam", "breeder", "exhibitor"]

  func validateSheet() -> String? {
    var faults = "Have not given "
    var okToGo = true
    var count = 0
    
    // Check to see all compusary fields have been entered
    // ----------------------------------------------------
    for fault in possibleFaults {
      let value = self.valueForKey(fault) as! String
      if value.isEmpty {
        if count++ > 0 {
          faults += ", "
        }
        faults += fault
        okToGo = false
      }
    }
    
    // Now check to see if kitten is not too old or too young,  or if the cat should be in kittens
    // -------------------------------------------------------------------------------------------
    if okToGo {
      faults = ""
    } else {
      faults += ".\n"
    }
    
    if let currentShow = Globals.currentShow {
      
      // Check for a cat entered as a kitten or vice versa
      // ----------------------------------------------------
      let itIsAKitten = currentShow.isKittenIfBornOn(self.birthDate)
      if  Challenges.isAKitten(self.challenge) {

        // it is entered as a kitten
        // ----------------------------------------------------
        if !itIsAKitten {

          // but it is not
          // ----------------------------------------------------
          okToGo = false
          faults += "This cat is too old to be a kitten.\n"
        }
      } else

        // it is entered as a cat/desexed
        // ----------------------------------------------------
        if itIsAKitten {

          // but it is a kitten
          // ----------------------------------------------------
          okToGo = false
          faults += "This cat should be in kittens.\n"
      }
      
      // Check to see the cat is not too young for the show
      // ---------------------------------------------------
      let isTooYoungForShow = currentShow.isItTooYoungForShow(self.birthDate)
      if  isTooYoungForShow {
        okToGo = false
        faults += "This kitten is under age.\n"
      }
      
      // Ensure 'Pending' is not used as registration for pedigree cats older than 4 months
      // -----------------------------------------------------------------------------------
      let pendingAllowed = currentShow.canItBePending(self.birthDate)
      if !Breeds.nonPedigreeBreed(self.breed) && !pendingAllowed {
        okToGo == false
        faults += "This kitten is too old for pending.\n"
      }
      
    } else {
      errorAlert(message: "!! No show date specified !!\nLocation: EntryShowController.validateSheet")
    }
    
    if okToGo {
      return nil
    } else {
      return faults
    }
  }
  
  // =============================================
  //: # MARK: - IBActions
  // =============================================
  
  @IBAction func okButtonPressed(sender: NSButton) {
    if let faults = self.validateSheet() {
      errorAlert(message: faults)
    } else {
      window!.endEditingFor(nil)
      print("dismissing entry sheet with OK response")
      dismissWithModalResponse(NSModalResponseOK)
    }
  }
  
  @IBAction func cancelButtonPressed(sender: NSButton) {
    print("dismissing entry sheet with cancel response")
    dismissWithModalResponse(NSModalResponseCancel)
  }
  
  func dismissWithModalResponse(response: NSModalResponse)
  {
    window!.sheetParent!.endSheet(window!, returnCode: response)
  }
 
}
