//
//  Colours.swift
//  CatBase
//
//  Created by John Sandercock on 9/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

var coloursToken: Int = 0

class Colours: DataSource, NSTableViewDataSource {
  
  // breedSource must be bound to a control which will return a valid breed name
  // ----------------------------------------------------------------------------
  @IBOutlet weak var breedSource: NSControl!
  
  override init() {
    super.init()
    limitToList = true
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    limitToList = true
  }
  
  // *************************
  // MARK: - class properties
  // *************************
  
  static var isDirty = false
  
  static var entity = "Colours"
  fileprivate static var list = DictOfStringArray() {
    didSet {
      isDirty = true
    }
  }

  // *************************
  // MARK: - class methods
  // *************************
  
  class func createList() {
     list = dictFromPList(Colours.entity) as! DictOfStringArray
  }
  
  class func saveColours() {
    if isDirty {
      if !dict(list as NSDictionary, toPlist: Colours.entity) {
        print("Could not save colours")
      }
      isDirty = false
    }
  }
  
  class func rank(of colour: String, forBreed breed: String) -> Int? {
    guard let colours = Colours.list[breed]
      else { return nil }
    return colours.index(of: colour)
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
        if let answer = Colours.list[currentBreed!] {
          return answer
        }
      }
      return []
    }
  }
  
  // *************************
  // MARK: - instance methods
  // *************************
  
  fileprivate func indexInBounds(_ index: Int) -> Bool {
    return (index > -1 && index < self.list.count)
  }
  
  func  colourAtIndex(_ index: Int) -> String {
    if indexInBounds(index) && currentBreed != nil && !currentBreed!.isEmpty {
      return Colours.list[currentBreed!]![index]
    } else {
      return "No colour"
    }
  }
  
  func setIndex(_ index: Int, toColour newColour:String) {
    if indexInBounds(index) && currentBreed != nil && !currentBreed!.isEmpty {
      Colours.list[currentBreed!]![index] = newColour
    }
  }
  
  func addNewColour(_ newColour: String, atIndex index: Int) {
    guard index >= 0  else { print("addNewColour given a negative index"); return }
    guard index <= self.list.count  else { print("addNewColour given too large an index"); return }
    guard let currentBreed = self.currentBreed else { print("addNewColour: currentBreed is nil"); return }
    guard Colours.list[currentBreed] != nil else { print("addNewColour: list of colours for /(currentBreed) is nil"); return }
    if index == self.list.count {     // at end of list, so append a new colour
      Colours.list[currentBreed]!.append(newColour)
    } else {                          // otherwise insert it at location index
      Colours.list[currentBreed]!.insert(newColour, at: index)
    }
  }
  
  func removeColourAtIndex(_ index: Int) {
    if indexInBounds(index)  && currentBreed != nil && !currentBreed!.isEmpty {
      Colours.list[currentBreed!]!.remove(at: index)
    }
  }
  
  // ************************************
  // MARK: - TableView datasource methods
  // ************************************
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.list.count
  }
  
  func tableView(_ aTableView: NSTableView,
    objectValueFor aTableColumn: NSTableColumn?,
    row rowIndex: Int) -> Any? {
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
  
  override func firstRowMatchingPrefix(_ prefix: String) -> String? {
    let lowerCasePrefix = prefix.lowercased()
    var currentChoice: String? = nil
    
    // find the smallest string that matches
    for string in list {
      if string.lowercased().hasPrefix(lowerCasePrefix) {
        if currentChoice == nil {
          currentChoice = string
        } else if string.count < currentChoice!.count {
          currentChoice = string
        }
      }
    }
    return currentChoice
  }
}
