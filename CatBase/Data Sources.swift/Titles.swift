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
  
  @IBOutlet weak var titleTable: NSTableView!
  
  override class func initialize() {
    dispatch_once(&titlesToken) {
      let temp = arrayFromPList(Titles.entity)
      if temp != nil {
        list = temp as! [String]
      } else {
        fatalError("Cannot read in Titles list")
      }
    }
  }
  
  class func saveTitles() {
    print("Titles are now:")
    print(list)
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
  
  func titleAtindex(index: Int) -> String {
    if index < Titles.list.count {
      return Titles.list[index]
    }
    return ""
  }
  
  func setIndex(index: Int, toTitle newValue: String) {
    let i = index < 0 ? 0 : index
    let j = i < Titles.list.count ? i : Titles.list.count - 1
    Titles.list[j] = newValue
  }
  
  func insertNewTitleAtIndex(index: Int) {
    let i = index < 0 ? 0 : index
    if i < Titles.list.count {
      Titles.list.insert("", atIndex: i)
    } else {
      Titles.list.append("")
    }
  }
  
  func addNewTitle(newValue: String, atIndex index: Int) {
    let i = index < 0 ? 0 : index
    if i < Titles.list.count {
      Titles.list.insert(newValue, atIndex: i)
    } else {
      Titles.list.append(newValue)
    }
  }
  
  func removeTitleAtIndex(index: Int) {
    let i = index < 0 ? 0 : index
    let j = i < Titles.list.count ? i : Titles.list.count - 1
    Titles.list.removeAtIndex(j)
  }
  
  // ==============================
  // MARK: - Combo box data sources
  // ==============================
  
  override func firstRowMatchingPrefix(prefix: String) -> String? {
    var currentChoice: String? = nil
    let words = prefix.componentsSeparatedByString(" ")
    let lowerCasePrefix = words.last?.lowercaseString
    
    if let lowerCasePrefix = lowerCasePrefix {
      for string in list {
        if string.lowercaseString.hasPrefix(lowerCasePrefix) {
          if currentChoice == nil {
            currentChoice = string
          } else if string.characters.count < currentChoice!.characters.count {
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
  
  // ==============================
  // MARK: - Tableview data sources
  // ==============================
  
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
}
