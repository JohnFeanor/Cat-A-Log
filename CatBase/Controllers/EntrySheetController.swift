//
//  EntrySheetController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

struct EntrySheetData {
  var registration        = "Pending"
  var title               = ""
  var name                = ""
  var breed               = ""
  var colour              = ""
  var sex                 = ""
  var challenge           = ""
  var birthDate           = NSDate()
  var sire                = ""
  var dam                 = ""
  var breeder             = ""
  var exhibitor           = ""
  
  var cageType            = NSNumber(integer: 0)
  var cageSize            = NSNumber(integer: 110)
  var hireCage            = NSNumber(bool: false)
  var litter              = NSNumber(bool: false)
  
  var ring1               = NSNumber(bool: true)
  var ring2               = NSNumber(bool: true)
  var ring3               = NSNumber(bool: true)
  var ring4               = NSNumber(bool: false)
  var ring5               = NSNumber(bool: false)
  var ring6               = NSNumber(bool: false)
  var willWork            = NSNumber(bool: false)
  var catalogueRequired   = NSNumber(bool: false)
  var vaccinated          = NSNumber(bool: false)
}

class EntrySheetController: NSWindowController {

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
  
  // MARK: - Entry sheet items
  
  var entrySheetData = EntrySheetData()
  
  dynamic var registration: String {
    get {
      return self.entrySheetData.registration
    }
    set {
      self.entrySheetData.registration = newValue
    }
  }
  
  dynamic var title: String {
    get {
      return self.entrySheetData.title
    }
    set {
      self.entrySheetData.title = newValue
    }
  }
  
  dynamic var name: String {
    get {
      return self.entrySheetData.name
    }
    set {
      self.entrySheetData.name = newValue
      let prefixes = newValue.componentsSeparatedByString(" ")
      if !prefixes.isEmpty {
        if sire.isEmpty {
          sire = prefixes[0] + " "
        }
        if dam.isEmpty {
          dam = prefixes[0] + " "
        }
      }
    }
  }
  
  dynamic var breed: String {
    get {
      return self.entrySheetData.breed
    }
    set {
      self.entrySheetData.breed = newValue
    }
  }
  
  dynamic var colour: String {
    get {
      return self.entrySheetData.colour
    }
    set {
      self.entrySheetData.colour = newValue
    }
  }
  
  dynamic var sex: String {
    get {
      return self.entrySheetData.sex
    }
    set {
      self.entrySheetData.sex = newValue
      print("cat sex is now \(newValue)")
    }
  }
  
  dynamic var challenge: String {
    get {
      return self.entrySheetData.challenge
    }
    set {
      self.entrySheetData.challenge = newValue
    }
  }
  
  dynamic var birthDate: NSDate {
    get {
      return self.entrySheetData.birthDate
    }
    set {
      self.entrySheetData.birthDate = newValue
    }
  }
  
  dynamic var sire: String {
    get {
      return self.entrySheetData.sire
    }
    set {
      self.entrySheetData.sire = newValue
    }
  }
  
  dynamic var dam: String {
    get {
      return self.entrySheetData.dam
    }
    set {
      self.entrySheetData.dam = newValue
    }
  }
  
  dynamic var breeder: String {
    get {
      return self.entrySheetData.breeder
    }
    set {
      self.entrySheetData.breeder = newValue
      if self.exhibitor.isEmpty {
        self.exhibitor = newValue
      }
    }
  }
  
  dynamic var exhibitor: String {
    get {
      return self.entrySheetData.exhibitor
    }
    set {
      print("Setting exhibitor to \(newValue)")
      self.entrySheetData.exhibitor = newValue
    }
  }
  
  dynamic var cageType: NSNumber {
    get {
      return self.entrySheetData.cageType
    }
    set {
      self.entrySheetData.cageType = newValue
    }
  }
  
  dynamic var cageSize: NSNumber {
    get {
      return self.entrySheetData.cageSize
    }
    set {
      self.entrySheetData.cageSize = newValue
    }
  }
  
  dynamic var hireCage: NSNumber {
    get {
      return self.entrySheetData.hireCage
    }
    set {
      self.entrySheetData.hireCage = newValue
    }
  }
  
  dynamic var litter: NSNumber {
    get {
      return self.entrySheetData.litter
    }
    set {
      self.entrySheetData.litter = newValue
    }
  }
  
  dynamic var ring1: NSNumber {
    get {
      return self.entrySheetData.ring1
    }
    set {
      self.entrySheetData.ring1 = newValue
    }
  }
  
  dynamic var ring2: NSNumber {
    get {
      return self.entrySheetData.ring2
    }
    set {
      self.entrySheetData.ring2 = newValue
    }
  }
  
  dynamic var ring3: NSNumber {
    get {
      return self.entrySheetData.ring3
    }
    set {
      self.entrySheetData.ring3 = newValue
    }
  }
  
  dynamic var ring4: NSNumber {
    get {
      return self.entrySheetData.ring4
    }
    set {
      self.entrySheetData.ring4 = newValue
    }
  }
  
  dynamic var ring5: NSNumber {
    get {
      return self.entrySheetData.ring5
    }
    set {
      self.entrySheetData.ring5 = newValue
    }
  }
  
  dynamic var ring6: NSNumber {
    get {
      return self.entrySheetData.ring6
    }
    set {
      self.entrySheetData.ring6 = newValue
    }
  }
  
  dynamic var willWork: NSNumber {
    get {
      return self.entrySheetData.willWork
    }
    set {
      self.entrySheetData.willWork = newValue
    }
  }
  
  dynamic var catalogueRequired: NSNumber {
    get {
      return self.entrySheetData.catalogueRequired
    }
    set {
      self.entrySheetData.catalogueRequired = newValue
    }
  }
  
  dynamic var vaccinated: NSNumber {
    get {
      return self.entrySheetData.vaccinated
    }
    set {
      self.entrySheetData.vaccinated = newValue
    }
  }

  // MARK: - Methods
  
  override var windowNibName: String {
    return "EntrySheetController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  // =============================================
  // MARK: - Ensure all data needed is in and OK
  // =============================================

  // list of the fields that must be filled in correctly
  // ----------------------------------------------------
  let possibleFaults = ["registration", "name", "breed", "colour", "sex", "challenge", "sire", "dam", "breeder", "exhibitor"]

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
      if self.challenge == Challenges.kitten() {

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
      print("!! EntrySheetController cannot get a show date !!")
    }
    
    if okToGo {
      return nil
    } else {
      return faults
    }
  }
  
  // =============================================
  // MARK: - IBActions
  // =============================================
  
  @IBAction func okButtonPressed(sender: NSButton) {
    if let faults = self.validateSheet() {
      errorAlert(message: faults)
    } else {
      window?.endEditingFor(nil)
      print("dismissing entry sheet with OK response")
      print("Sheet values are:")
      print(entrySheetData)
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
