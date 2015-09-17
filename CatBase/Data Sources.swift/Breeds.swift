//
//  Breeds.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

var breedsToken: dispatch_once_t = 0

private struct BreedList {
  var groupName = ""
  var breeds = [String]()
}

class Breeds: DataSource, NSTableViewDataSource {
  
  static var entity = "Breeds"
  private static var breedsByGroupAndShowtype   = [String : [BreedList]]()
  private static var nonPedigreesByShowType = [String : [String]]()
  
  private static var groups:[BreedList]? {
    return Breeds.breedsByGroupAndShowtype[Globals.currentShowType]
  }
  
  private static var list: [String]? {
      if let groups = Breeds.groups {
        var ans = [String]()
        for group in groups {
          ans += group.breeds
        }
        return ans
      }
    print("Breeds: breedsByGroupAndShowtype is nil")
    return nil
  }
  
  // ************************************
  // MARK: - Class initializer
  // ************************************
  
  override class func initialize() {
    dispatch_once(&breedsToken) {       // This will only ever execute once
      
      // load in an array of the group names & breeds in the group for each of the show types
      // for each show type e.g. QFA, ACF or COWOCA
      for (showTypeName, showTypeData) in Globals.dataByGroup {
        let groups = showTypeData.valueForKey(Headings.groups) as! [[String : AnyObject]]
        var tempBreeds = [BreedList]()
        for group in groups {
          let groupBreeds = group[Headings.breeds] as! [String]
          let groupName = group[Headings.group] as! String
          tempBreeds.append(BreedList(groupName: groupName, breeds: groupBreeds))
        }
        if let nonPedigree = groups.last {
          nonPedigreesByShowType[showTypeName] = (nonPedigree[Headings.breeds] as! [String])
        }
        breedsByGroupAndShowtype[showTypeName] = tempBreeds
      }
    }
  }
  
  // ************************************
  // MARK: - Class methods
  // ************************************
  
  class func nonPedigreeBreed(breedName: String) -> Bool {
    if let currentBreeds = Breeds.nonPedigreesByShowType[Globals.currentShowType] {
      return currentBreeds.contains(breedName)
    }
    return false
  }
  
  class func groupNumberOf(breedName: String) -> Int? {
    if let groups = Breeds.groups {
      var breedsGroup = 0
      for group in groups {
        if group.breeds.contains(breedName) {
          return breedsGroup
        }
        breedsGroup++
      }
      print("group number for \(breedName) not found")
    }
    return nil
  }
  
  class func ACFgroupNumberOf(breedName: String) -> Int {
    if let groups = Breeds.breedsByGroupAndShowtype["ACF Show"] {
      var breedsGroup = 0
      for group in groups {
        if group.breeds.contains(breedName) {
          return breedsGroup
        }
        breedsGroup++
      }
      fatalError("Cannot determine ACF group number for \(breedName)")
    }
    fatalError("Cannot find breeds for ACF type show")
  }
  
  class func nameOfGroupForBreed(breedName: String) -> String {
    if let groups = Breeds.groups {
      var breedsGroup = 0
      for group in groups {
        if group.breeds.contains(breedName) {
          return groups[breedsGroup].groupName
        }
        breedsGroup++
      }
    }
    fatalError("group name for \(breedName) not found")
  }
  
  class func nameOfGroupNumber(index: Int) -> String? {
    if let groups = Breeds.groups {
      if (index < 0) || (index >= groups.count) {
        print("name for group \(index) not found")
      } else {
        return groups[index].groupName
      }
    }
    return nil
  }
  
  class func rankOf(breedName: String) -> Int? {
    if let list = Breeds.list {
      return list.indexOf(breedName)
    }
    return nil
  }
  
  class func nameOf(index: Int) -> String {
    if let list = Breeds.list {
      if (index < 0) || (index >= list.count) {
        fatalError("Out of bounds. Breed name for index: \(index)")
      } else {
        return list[index]
      }
    }
    fatalError("Cannot access Breed name list in nameOf:")
  }
  
  static var numberOfBreeds: Int {
    if let list = Breeds.list {
        return list.count
    }
    return 0
  }

  // ************************************
  // MARK: - the list
  // ************************************
  
  override var list: [String] {
    guard let groups = Breeds.breedsByGroupAndShowtype[Globals.currentShowType]
      else { return [] }
    
    var answer = [String]()
    for group in groups {
      answer += group.breeds
    }
    return answer
  }
  
  // ************************************
  // MARK: - ComboBox datasource methods
  // ************************************
  
  func comboBox(aComboBox: NSComboBox, indexOfItemWithStringValue aString: String) -> Int {
    var count = 0
    for s in list {
      if aString == s {
        break
      }
      count++
    }
    return count
  }
  
  // ************************************
  // MARK: - TableView datasource methods
  // ************************************
  
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    let count = self.list.count
    return count
  }
  
  func tableView(aTableView: NSTableView,
    objectValueForTableColumn aTableColumn: NSTableColumn?,
    row rowIndex: Int) -> AnyObject? {
      if rowIndex < self.list.count && rowIndex > -1 {
        return self.list[rowIndex]
      } else {
        print("Asked for value of breed row: \(rowIndex) out of bounds: \(self.list.count)")
        return ""
      }
  }
  
}