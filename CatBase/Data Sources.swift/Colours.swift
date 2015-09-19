//
//  Colours.swift
//  CatBase
//
//  Created by John Sandercock on 9/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

var coloursToken: dispatch_once_t = 0

class Colours: DataSource, NSTableViewDataSource {
  
  // breedSource must be bound to a control which will return a valid breed name
  // ----------------------------------------------------------------------------
  @IBOutlet weak var breedSource: NSControl!
  
  override init() {
    super.init()
    limitToList = true
  }
  
  // *************************
  // MARK: - class properties
  // *************************
  
  static var isDirty = false
  
  static var entity = "Colours"
  private static var list = DictOfStringArray() {
    didSet {
      isDirty = true
    }
  }

  // *************************
  // MARK: - class methods
  // *************************
  
  override class func initialize() {
    dispatch_once(&coloursToken) {
      list = dictFromPList(Colours.entity) as! DictOfStringArray
    }
  }
  
  class func saveColours() {
    if isDirty {
      if !dict(list as NSDictionary, toPlist: Colours.entity) {
        print("Could not save colours")
      }
      isDirty = false
    }
  }
  
  class func rankOf(colour: String, forBreed breed: String) -> Int? {
    guard let colours = Colours.list[breed]
      else { return nil }
    return colours.indexOf(colour)
  }
  
  
  // ****************************
  // MARK: - instance properties
  // ****************************
  
  var currentBreed: String? {
    guard let breedSource = breedSource
      else { return nil }
    return breedSource.currentBreed
  }
  
  override var list: [String] {
    get {
      if currentBreed != nil && !currentBreed!.isEmpty {
        return Colours.list[currentBreed!]!
      } else {
        return []
      }
    }
  }
  
  // *************************
  // MARK: - instance methods
  // *************************
  
  private func indexInBounds(index: Int) -> Bool {
    return (index > -1 && index < self.list.count)
  }
  
  func  colourAtIndex(index: Int) -> String {
    if indexInBounds(index) && currentBreed != nil && !currentBreed!.isEmpty {
      return Colours.list[currentBreed!]![index]
    } else {
      return "No colour"
    }
  }
  
  func setIndex(index: Int, toColour newColour:String) {
    if indexInBounds(index) && currentBreed != nil && !currentBreed!.isEmpty {
      Colours.list[currentBreed!]![index] = newColour
    }
  }
  
  func addNewColour(newColour: String, atIndex index: Int) {
    if indexInBounds(index) && currentBreed != nil && !currentBreed!.isEmpty {
      Colours.list[currentBreed!]!.insert(newColour, atIndex: index)
    }
  }
  
  func removeColourAtIndex(index: Int) {
    if indexInBounds(index)  && currentBreed != nil && !currentBreed!.isEmpty {
      Colours.list[currentBreed!]!.removeAtIndex(index)
    }
  }
  
  // ************************************
  // MARK: - TableView datasource methods
  // ************************************
  
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return self.list.count
  }
  
  func tableView(aTableView: NSTableView,
    objectValueForTableColumn aTableColumn: NSTableColumn?,
    row rowIndex: Int) -> AnyObject? {
      if indexInBounds(rowIndex) {
        return self.list[rowIndex]
      } else {
        print("Asked for value of colour row: \(rowIndex) out of bounds: \(self.list.count)")
        return ""
      }
  }
  
  // ==============================
  // MARK: - Combo box data sources
  // ==============================
  
  override func firstRowMatchingPrefix(prefix: String) -> String? {
    let lowerCasePrefix = prefix.lowercaseString
    var currentChoice: String? = nil
    
    // find the smallest string that matches
    for string in list {
      if string.lowercaseString.hasPrefix(lowerCasePrefix) {
        if currentChoice == nil {
          currentChoice = string
        } else if string.characters.count < currentChoice!.characters.count {
          currentChoice = string
        }
      }
    }
    return currentChoice
  }
}
