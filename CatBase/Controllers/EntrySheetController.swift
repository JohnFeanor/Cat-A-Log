//
//  EntrySheetController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

private let zero  = 0
private let NO    = false
private let YES   = true

import Cocoa

class EntrySheetController: NSWindowController {

// -------------------------------
  @IBOutlet weak var cageSizeTextField: NSTextField!
  @IBOutlet weak var initialTextField: NSTextField!
  @IBOutlet weak var datePicker: NSDatePicker!
  
  @objc var dateSet = false
  
  @objc var managedObjectContext: NSManagedObjectContext!
  
  @objc var entryData: [String : AnyObject] {
    let properties = Entry.properties + Cat.properties
    return self.dictionaryWithValues(forKeys: properties) as [String : AnyObject]
  }
  
  @objc let cageNames = Globals.cageTypes.names
  @objc let cageSizes = Globals.cageTypes.sizes
  
  @objc let _litterCage: Int = {
    if Globals.cageTypes.names.count > 0 {
      return Globals.cageTypes.names.count - 1
    } else {
      return 0
    }
  }()
  
  @objc let _hireCage: Int = {
    if Globals.cageTypes.names.count > 1 {
      return Globals.cageTypes.names.count - 2
    } else {
      return 0
    }
  }()
  
  @objc let _otherCage: Int = {
    if Globals.cageTypes.names.count > 2 {
      return Globals.cageTypes.names.count - 3
    } else {
      return 0
    }
    }()

  // MARK: - Entry sheet items
  // -------------------------
  @objc dynamic var registration = pending {
    didSet {
      // find out if this cat is in the database
      // and fill in the details if it is
      if registration != pending && !filledFields {
        let same = fetchCatsWithRegistration(registration, inContext: self.managedObjectContext)
        let cat = same.first
        setSheetTo(cat, except: [Cat.registration, Cat.title])
        if title.isEmpty && cat != nil {
          title = cat!.title
        }
      }
    }
  }
  @objc dynamic var title = String()
  @objc dynamic var name = String() {
    didSet {
      let prefixes = name.components(separatedBy: " ")
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
        setSheetTo(cat, except: [Cat.registration, Cat.title, Cat.name])
        let noRego = registration.isEmpty || registration == pending
        if noRego && cat != nil {
          registration = cat!.registration
        }
        if title.isEmpty && cat != nil {
          title = cat!.title
        }
      }
    }
  }
  
  @objc dynamic var breed     = String()
  @objc dynamic var colour    = String()
  @objc dynamic var sex       = String()
  @objc dynamic var challenge = String() {
    didSet {
      if challenge != Challenges.name(ranked: ChallengeTypes.kitten) && !dateSet {
        let showdate = Globals.currentShow?.date ?? Date()
        let calendar = Calendar.current
        if let lastYear = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.year, value: -1, to: showdate, options: []) {
          birthDate = lastYear
        }
      }
    }
  }
  @objc dynamic var birthDate: Date = {
    let showdate = Globals.currentShow?.date ?? Date()
    return (Calendar.current as NSCalendar).date(byAdding: .month, value: -5, to: showdate, options: []) ?? showdate
    }()
  
  @objc dynamic var sire      = String()
  @objc dynamic var dam       = String()
  @objc dynamic var exhibitor = String()
  @objc dynamic var breeder   = String() {
    didSet {
      if self.exhibitor.isEmpty {
        self.exhibitor = breeder
      }
    }
  }
  
  @objc dynamic var cageType = zero {
    didSet {
      cageSize = Globals.cageTypes.sizes[cageType]
      if cageSize == _otherCage {
        enableCageSizeTextField = true
        self.window?.makeFirstResponder(self.cageSizeTextField)
      } else {
        enableCageSizeTextField = false
        if oldValue == _otherCage {
          self.window?.makeFirstResponder(initialTextField)
        }
      }
      litterCage = (cageType == _litterCage)
      hireCage = (cageType == _hireCage)
    }
  }
  @objc dynamic var cageSize = Globals.cageTypes.sizes[0]
  
  @objc dynamic var hireCage    = false
  @objc dynamic var litterCage  = false
  
  @objc dynamic var ring1 = true
  @objc dynamic var ring2 = Globals.currentShow!.numberOfRings.intValue > 1
  @objc dynamic var ring3 = Globals.currentShow!.numberOfRings.intValue > 2
  @objc dynamic var ring4 = Globals.currentShow!.numberOfRings.intValue > 3
  @objc dynamic var ring5 = Globals.currentShow!.numberOfRings.intValue > 4
  @objc dynamic var ring6 = Globals.currentShow!.numberOfRings.intValue > 5
  
  @objc dynamic var ring1Available = true
  @objc dynamic var ring2Available = Globals.currentShow!.numberOfRings.intValue > 1
  @objc dynamic var ring3Available = Globals.currentShow!.numberOfRings.intValue > 2
  @objc dynamic var ring4Available = Globals.currentShow!.numberOfRings.intValue > 3
  @objc dynamic var ring5Available = Globals.currentShow!.numberOfRings.intValue > 4
  @objc dynamic var ring6Available = Globals.currentShow!.numberOfRings.intValue > 5
  
  @objc dynamic var willWork = false
  @objc dynamic var catalogueRequired = false
  @objc dynamic var vaccinated = false
  
  // MARK: - Other variables for sheet
  // ---------------------------------
  @objc dynamic var enableCageSizeTextField = false
  @objc var filledFields = false

  // ****************
  // MARK: - Methods
  // ****************
  
  @IBAction func cageSizeMenuChosen(_ sender: NSPopUpButton) {
    // not doing anything, just ensuring this class is the target of the popup
  }
  
  override var windowNibName: NSNib.Name? {
    return "EntrySheetController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
//    let dateFormatter = DateFormatter()
//    datePicker.delegate = dateFormatter
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  
  // Litter cage type not selectable unless the entry is a kitten
  // -------------------------------------------------------------
  func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
    let selector = menuItem.action
    let tag = menuItem.tag
    if (tag == _litterCage) && (selector == #selector(EntrySheetController.cageSizeMenuChosen(_:))) {
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
  @objc func setSheetTo(_ original: Cat?, except exceptions: [String]?) {
    if let original = original {
      dateSet = true
      filledFields = true
      let properties: [String]
      if exceptions == nil {
        properties = Cat.properties
      } else {
        properties = Cat.properties.filter { !exceptions!.contains($0) }
      }
      for key in properties {
        self.setValue(original.value(forKey: key), forKey: key)
      }
    }
  }
  
  @objc func setSheetTo(_ original: Entry) {
    for key in Cat.properties {
      dateSet = true
      filledFields = true
      self.setValue(original.cat.value(forKey: key), forKey: key)
    }
    for key in Entry.properties {
      self.setValue(original.value(forKey: key), forKey: key)
    }
    // set the cage type menu
    if let index = Globals.cageTypes.sizes.firstIndex(of: original.cageSize.intValue) {
      cageType = index
    } else {
      cageType = zero
    }
    if original.hireCage.boolValue {
      cageType = _hireCageNumber
    }
  }
  
  fileprivate func checkField(_ field: String) -> Bool {
    if let theField = self.value(forKey: field) as? String {
      if theField.isEmpty { return false }
      switch field {
      case Cat.sex:
        return Sex.rank(of: theField) != nil
      case Cat.breed:
        return Breeds.rank(of: theField) != nil
      default:
        break;
      }
    }
    return true
  }
  


  // =============================================
  // MARK: - Ensure all data needed is in and OK
  // =============================================

  // list of the fields that must be filled in correctly
  // ----------------------------------------------------
  fileprivate let possibleFaults = ["registration", "name", "breed", "colour", "sex", "challenge", "sire", "dam", "breeder", "exhibitor"]

  @objc func validateSheet() -> String? {
    
    var faults = "Have not given "
    var okToGo = true
    var count = 0
    
    // Check to see all compulsary fields have been entered
    // ----------------------------------------------------
    for fault in possibleFaults {
      
      if !checkField(fault) {
        if count > 0 {
          faults += ", "
        }
        count += 1
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
      } else if itIsAKitten {
        
        // entered as cat but it is a kitten
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
      
      // Check to see kitten is not too old to be in litter
      // ---------------------------------------------------
      let isTooOldForLitter = !currentShow.canItBeInALitter(self.birthDate)
      if isTooOldForLitter && litterCage {
        okToGo = false
        faults += "This kitten is too old to be in a litter.\n"
      }
      
      // Ensure 'Pending' is not used as registration for pedigree cats older than 4 months
      // -----------------------------------------------------------------------------------
      if registration.isPending && Breeds.pedigree(breed: self.breed) && !currentShow.canItBePending(self.birthDate) {
        okToGo = false
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
  
  @IBAction func okButtonPressed(_ sender: NSButton) {
    if let faults = self.validateSheet() {
      errorAlert(message: faults)
    } else {
      window!.endEditing(for: nil)
      speaker.startSpeaking("adding \(self.name)")
      dismissWithModalResponse(NSApplication.ModalResponse.OK)
    }
  }
  
  @IBAction func cancelButtonPressed(_ sender: NSButton) {
    speaker.startSpeaking("Cancelled")
    dismissWithModalResponse(NSApplication.ModalResponse.cancel)
  }
  
  @objc func dismissWithModalResponse(_ response: NSApplication.ModalResponse)
  {
    window!.sheetParent!.endSheet(window!, returnCode: response)
  }
  
  @IBAction func datePressed(_ sender: AnyObject) {    
    dateSet = true
  }

}
