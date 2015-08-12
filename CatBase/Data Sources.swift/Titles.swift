//
//  Titles.swift
//  CatBase
//
//  Created by John Sandercock on 11/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

var titlesToken: dispatch_once_t = 0

class Titles: DataSource {
  
  static var entity = "Titles"
  static var list = [String]()
  
  var currentBreed: String? = nil
  
  override class func initialize() {
    dispatch_once(&titlesToken) {
      let temp = arrayFromPList(Titles.entity)
      if temp != nil {
        list = temp!
      } else {
        fatalError("Cannot read in Titles list")
      }
    }
  }
  
  class func saveTitles() {
    if !array(list, ToPlist: Titles.entity) {
      print("Could not save the tiles")
    }
  }
  
  override var list: [String] {
    return Titles.list
  }
  
  func count() -> Int {
    return list.count
  }
  
  // MARK: - Insert or delete titles
  
  func insertNewTitleAtIndex(index: Int) {
    Titles.list.insert("", atIndex: index)
  }
  
  func removeObjectAtIndex(index: Int) {
    Titles.list.removeAtIndex(index)
  }
  
  // MARK: - Data source methods
  
  
  override func firstRowMatchingPrefix(prefix: String) -> String? {
    var currentChoice: String? = nil
    let words = prefix.componentsSeparatedByString(" ")
    let lowercaseprefix = words.last?.lowercaseString
    
    if let lowercaseprefix = lowercaseprefix {
      for string in list {
        if string.lowercaseString.hasPrefix(lowercaseprefix) {
          if currentChoice == nil {
            currentChoice = string
          } else if string.characters.count < (currentChoice!).characters.count {
            currentChoice = string
          }
        }
      }
    }
    if currentChoice == nil {
      // cannot find a completion, so just return the original string
      return prefix
    } else {
      // found a completion
      // return the completed last word appended to all the other words
      let wordCount = words.count - 1
      var answer = ""
      var i = 0
      while i < wordCount {
        answer += words[i++] + " "
      }
      return (answer + currentChoice!)
    }
  }
  
  func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
    if list.isEmpty {
      return 0
    } else {
      return list.count
    }
  }
  
    func tableView(aTableView: NSTableView, objectValueForTableColumn aTableColum: NSTableColumn, row rowIndex: Int) -> AnyObject? {
      if list.isEmpty {
        return nil
      } else {
        return list[rowIndex] as AnyObject
      }
    }
    
    func tableView(aTableView: NSTableView, setObjectValue anObject: AnyObject?, forTableColumn: NSTableColumn?, row rowIndex: Int) {
      let newValue = anObject as? String
      if newValue != nil {
        Titles.list[rowIndex] = newValue!
      } else {
        print("Titles setObjectValue passed a non string")
      }
    }
}
