//
//  Breeds.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

var breedsToken: Int = 0

private struct BreedList {
  var groupName = ""
  var breeds = [String]()
}

class Breeds: DataSource, NSTableViewDataSource {
  
  static var entity = "Breeds"
  fileprivate static var breedsByGroupAndShowtype   = [String : [BreedList]]()
  fileprivate static var nonPedigreesByShowType = [String : [String]]()
  
  fileprivate static var groups:[BreedList]? {
    return Breeds.breedsByGroupAndShowtype[Globals.currentShowType]
  }
  
  fileprivate static var list: [String]? {
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
  // MARK: - Class methods
  // ************************************
  
  class func createList() {
    // load in an array of the group names & breeds in the group for each of the show types
    // for each show type e.g. QFA, ACF or COWOCA
    for (showTypeName, showTypeData) in Globals.dataByGroup {
      let groups = showTypeData.value(forKey: Headings.groups) as! [[String : AnyObject]]
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
  
  override init() {
    super.init()
    limitToList = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    limitToList = true
  }
  
  // ************************************
  // MARK: - Class methods
  // ************************************
  
  class func nonPedigreeBreed(_ breedName: String) -> Bool {
    guard let currentBreeds = Breeds.nonPedigreesByShowType[Globals.currentShowType]
      else { return false }
    return currentBreeds.contains(breedName)
  }
  
  class func pedigreeBreed(_ breedName: String) -> Bool {
    return !nonPedigreeBreed(breedName)
  }
  
  class func groupNumberOf(_ breedName: String) -> Int {
    let nameOfBreed: String
    if breedName == "Norwegian Forest" {
      nameOfBreed = "Norwegian Forest Cat"
    } else {
      nameOfBreed = breedName
    }
    if let groups = Breeds.groups {
      var breedsGroup = 0
      for group in groups {
        if group.breeds.contains(nameOfBreed) {
          return breedsGroup
        }
        breedsGroup += 1
      }
    }
    fatalError("Cannot find group number of breed: \(breedName)")
  }
  
  class func ACFgroupNumberOf(_ breedName: String) -> Int {
    let showType: String
    if Globals.currentShowType == "GCCFSA Show" {
      showType = "GCCFSA Show"
    } else {
       showType = "ACF Show"
    }
    if let groups = Breeds.breedsByGroupAndShowtype[showType] {
      let breed: String
      if breedName == "Norwegian Forest" {
        print("Changing Norwegian Forest to Norwegian Forest Cat")
        breed = "Norwegian Forest Cat"
      } else {
        breed = breedName
      }
      var breedsGroup = 0
      for group in groups {
        if group.breeds.contains(breed) {
          return breedsGroup
        }
        breedsGroup += 1
      }
      fatalError("Cannot determine ACF group number for \(breedName)")
    }
    fatalError("Cannot find breeds for ACF type show")
  }
  
  class func nameOfGroupForBreed(_ breedName: String) -> String {
    let nameOfBreed : String
    if breedName == "Norwegian Forest" {
      nameOfBreed = "Norwegian Forest Cat"
    } else {
      nameOfBreed = breedName
    }
    if let groups = Breeds.groups {
      var breedsGroup = 0
      for group in groups {
        if group.breeds.contains(nameOfBreed) {
          return groups[breedsGroup].groupName
        }
        breedsGroup += 1
      }
    }
    print("group name for \(nameOfBreed) not found")
    fatalError("group name for \(breedName) not found")
  }
  
  class func nameOfGroupNumber(_ index: Int) -> String {
    guard let groups = Breeds.groups
      else { fatalError("Breeds.group is nil") }
    if (index < 0) || (index >= groups.count) {
      fatalError("name for group \(index) not found")
    } else {
      return groups[index].groupName
    }
  }
  
  class func rankOf(_ breedName: String) -> Int? {
    if let list = Breeds.list {
      return list.index(of: breedName)
    }
    return nil
  }
  
  class func nameOf(_ index: Int) -> String {
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
  
  func comboBox(_ aComboBox: NSComboBox, indexOfItemWithStringValue aString: String) -> Int {
    var count = 0
    for s in list {
      if aString == s {
        break
      }
      count += 1
    }
    return count
  }
  
  // ************************************
  // MARK: - TableView datasource methods
  // ************************************
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    let count = self.list.count
    return count
  }
  
  func tableView(_ aTableView: NSTableView,
    objectValueFor aTableColumn: NSTableColumn?,
    row rowIndex: Int) -> Any? {
      if rowIndex < self.list.count && rowIndex > -1 {
        return self.list[rowIndex]
      } else {
        print("Asked for value of breed row: \(rowIndex) out of bounds: \(self.list.count)")
        return ""
      }
  }
  
}
