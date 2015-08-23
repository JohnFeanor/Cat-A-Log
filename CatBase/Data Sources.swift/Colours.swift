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
  
  static var entity = "Colours"
  static var list = DictOfStringArray()
  
  // breedSource must be bound to a control which will return a valid breed name
  
  @IBOutlet weak var breedSource: BreedSelector!
  
  var currentBreed: String? {
    if let breedSource = breedSource {
      return breedSource.currentBreed
    } else {
      return nil
    }
  }
  
  override class func initialize() {
    dispatch_once(&coloursToken) {
      list = dictFromPList(Colours.entity) as! DictOfStringArray
    }
  }
  
  func indexInBounds(index: Int) -> Bool {
    return (index > -1 && index < self.list.count)
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
}
