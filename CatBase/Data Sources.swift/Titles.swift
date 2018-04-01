//
//  Titles.swift
//  CatBase
//
//  Created by John Sandercock on 11/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

var titlesToken: Int = 0

class Titles: DataSource {
  
  static var nomen = "Titles"
  static var list = [String]()
  
  var currentBreed: String? = nil
  
  @IBOutlet weak var titleTable: NSTableView!
  
  class func createList() {
    let temp = arrayFromPList(Titles.nomen)
    if temp != nil {
      list = temp as! [String]
    } else {
      fatalError("Cannot read in Titles list")
    }
  }
  
  class func saveTitles() {
    if !array(list, ToPlist: Titles.nomen) {
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
  
  func titleAtindex(_ index: Int) -> String {
    if index < Titles.list.count {
      return Titles.list[index]
    }
    return ""
  }
  
  func setIndex(_ index: Int, toTitle newValue: String) {
    let i = index < 0 ? 0 : index
    let j = i < Titles.list.count ? i : Titles.list.count - 1
    Titles.list[j] = newValue
  }
  
  func insertNewTitleAtIndex(_ index: Int) {
    let i = index < 0 ? 0 : index
    if i < Titles.list.count {
      Titles.list.insert("", at: i)
    } else {
      Titles.list.append("")
    }
  }
  
  func addNewTitle(_ newValue: String, atIndex index: Int) {
    let i = index < 0 ? 0 : index
    if i < Titles.list.count {
      Titles.list.insert(newValue, at: i)
    } else {
      Titles.list.append(newValue)
    }
  }
  
  func removeTitleAtIndex(_ index: Int) {
    let i = index < 0 ? 0 : index
    let j = i < Titles.list.count ? i : Titles.list.count - 1
    Titles.list.remove(at: j)
  }
  
  // ==============================
  // MARK: - Combo box data sources
  // ==============================
  
  override func firstRowMatchingPrefix(_ prefix: String) -> String? {
    var currentChoice: String? = nil
    let words = prefix.components(separatedBy: " ")
    let lowerCasePrefix = words.last?.lowercased()
    
    if let lowerCasePrefix = lowerCasePrefix {
      for string in list {
        if string.lowercased().hasPrefix(lowerCasePrefix) {
          if currentChoice == nil {
            currentChoice = string
          } else if string.count < currentChoice!.count {
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
        answer += words[i] + " "
        i += 1
      }
      return (answer + currentChoice!)
    }
  }
  
  // ==============================
  // MARK: - Tableview data sources
  // ==============================
  
  func numberOfRowsInTableView(_ aTableView: NSTableView) -> Int {
    if list.isEmpty {
      return 0
    } else {
      return list.count
    }
  }
  
  func tableView(_ aTableView: NSTableView, objectValueForTableColumn aTableColum: NSTableColumn, row rowIndex: Int) -> AnyObject? {
    if list.isEmpty {
      return nil
    } else {
      return list[rowIndex] as AnyObject
    }
  }
}
