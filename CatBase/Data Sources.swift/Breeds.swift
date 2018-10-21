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
  static let companions: Set<String> = {
    let i = Set(nonPedigreesByShowType.flatMap{ $0.value })
    return i
  } ()
  
  fileprivate static var groups:[BreedList]? {
    if let ans = Breeds.breedsByGroupAndShowtype[Globals.currentShowType] { return ans }
    // if nil value returned, try to return the breed list of ACF
    return Breeds.breedsByGroupAndShowtype.sorted { return $0.key < $1.key }.first?.value
  }
  
  fileprivate static var list: [String]? {
    guard let groups = Breeds.groups
    else {
      print("Breeds: breedsByGroupAndShowtype is nil")
      return nil
    }
    return groups.reduce([], { $0 + $1.breeds })
  }
  
  // ************************************
  // MARK: - Class methods
  // ************************************
  
  class func createList() {
    // load in an array of the group names & breeds in the group for each of the show types
    // for each show type e.g. QFA, ACF or COWOCA
    for (showTypeName, showTypeData) in Globals.dataByGroup {
      let groups = showTypeData.value(forKey: Headings.groups) as! [[String : AnyObject]]
      let tempBreeds: [BreedList] = groups.reduce([], { total, g in
        return total + [BreedList(groupName: g[Headings.group] as! String, breeds: g[Headings.breeds] as! [String])] })

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
  
  class func nonPedigree(breed breedName: String) -> Bool {
    return companions.contains(breedName)
  }
  
  class func pedigree(breed breedName: String) -> Bool {
    return !companions.contains(breedName)
  }
  
  class func belongingTo(group: String) -> [String] {
    guard let showAffiliation = Globals.currentShow?.affiliation
      else { errorAlert(message: "No show is selected"); return [] }
    guard let breeds = Breeds.breedsByGroupAndShowtype[showAffiliation] else { errorAlert(message: "Internal error\nNo show type '\(showAffiliation)'"); return [] }
    let ans = breeds.first(where: { $0.groupName == group })?.breeds ?? []
    return ans
  }
  
  fileprivate class func groupNumber(of breedName: String, in groups: [BreedList]) -> Int {
    if let ans = groups.firstIndex(where: { $0.breeds.contains(breedName) }) {
      return ans
    }
    
    // handle the case where an exact match cannot be found
    let lcBreedName = breedName.firstWord().lowercased()
    if let ans = groups.firstIndex(where: { group in
      return group.breeds.contains(where: { $0.lowercased().hasPrefix(lcBreedName) || $0.lowercased().hasSuffix(lcBreedName)})
    }) {
      return ans
    }
    
    // cannot find this breed anywhere - is it a companion?
    if companions.contains(breedName), groups.count - 1 >= 0 {
      return groups.count - 1
   }
    
    // can not find any match with a breed - report an error
    fatalError("Cannot find group number of breed: \(breedName) in groupNumberOf")
  }
  
  class func groupNumber(of breedName: String) -> Int {
    guard let groups = Breeds.groups else {
      fatalError("Breeds.groups is nil in groupNumberOf")
    }
    return groupNumber(of: breedName, in: groups)
  }
  
  class func ACFgroupNumber(of breedName: String) -> ACFGroup {
    let showAffiliation = Globals.defaultShowAffliation
    guard let groups = Breeds.breedsByGroupAndShowtype[showAffiliation]
    else {
      fatalError("Breeds.group is nil for ACFgroupNumberOf")
    }
    return ACFGroup(rawValue: groupNumber(of: breedName, in: groups)) ?? .group1
  }
  
  class func groupName(for breedName: String) -> String {
    guard let groups = Breeds.groups
      else { fatalError("Breeds.group is nil for groupName for:") }
    
    if let ans = groups.first(where:
      { $0.breeds.contains(breedName)})?.groupName {
      return ans
    }
    
    // handle the case where an exact match cannot be found
    let lcBreedName = breedName.firstWord().lowercased()
    if let ans = groups.first(where: { group in
      return group.breeds.contains(where:
        { $0.lowercased().hasPrefix(lcBreedName) || $0.lowercased().hasSuffix(lcBreedName) }
      )
    }) {
      return ans.groupName
    }
    
    if companions.contains(breedName) {
      return groups[groups.count - 1].groupName
    }
    
    fatalError("group name for \(breedName) not found")
  }
  
  class func breedsInGroupWith(breed: String) -> Int {
    guard let groups = Breeds.groups
      else { fatalError("Breeds.group is nil for breedsInGroupWith breed:") }
    let ans = groups.filter({ $0.breeds.contains(breed)}).first?.breeds.count ?? 0
    return ans
  }
  
  class func nameOfGroupNumber(_ index: Int) -> String {
    guard let groups = Breeds.groups
      else { fatalError("Breeds.groups is nil") }
    guard (0 ..< groups.count) ~= index
      else { fatalError("\(index) out of range for Breeds.groups in nameOfGroupNumber") }
    return groups[index].groupName
  }
  
  class func rank(of breedName: String) -> Int? {
    guard let list = Breeds.list
      else { return nil }
    return list.index(of: breedName)
  }
  
  class func name(of index: Int) -> String {
    guard let list = Breeds.list
      else { fatalError("Breeds.list is nil") }
    guard (0 ..< list.count) ~= index
      else { fatalError("\(index) out of range for Breeds.list in name of:") }
    return list[index]
  }
  
  static var currentList: [String] {
    guard let groups = Breeds.breedsByGroupAndShowtype[Globals.currentShowType]
      else { return [] }
    return groups.reduce([], { $0 + $1.breeds})
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
    return Breeds.currentList
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
