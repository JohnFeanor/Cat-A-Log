//
//  Breeds.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

var breedsToken: dispatch_once_t = 0

class Breeds: DataSource {
  
  static var entity = "Breeds"
  private static var breedsByGroupAndShowtype   = [String : [String : [String]]]()
  private static var nonPedigreesByShowType = [String : [String]]()
  
  // ************************************
  // MARK: - Class initializer
  // ************************************
  
  override class func initialize() {
    dispatch_once(&breedsToken) {       // This will only ever execute once
      
      // load in an array of the group names & breeds in the group for each of the show types
      // for each show type e.g. QFA, ACF or COWOCA
      for (showTypeName, showTypeData) in Globals.dataByGroup {
        let groups = showTypeData.valueForKey(Headings.groups) as! [[String : AnyObject]]
        var tempBreeds = [String : [String]]()
        for group in groups {
          let groupBreeds = group[Headings.breeds] as! [String]
          let groupName = group[Headings.group] as! String
          tempBreeds[groupName] = groupBreeds
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
    if let theShow = Globals.currentShow {
      let currentShowType = theShow.affiliation
      if let currentBreeds = Breeds.nonPedigreesByShowType[currentShowType] {
        print("****\nNon pedigree breeds are:\n\(currentBreeds)\n****")
        return currentBreeds.contains(breedName)
      }
    }
    return false
  }
  
  // ************************************
  // MARK: - the list
  // ************************************
  
  override var list: [String] {
    if let theShow = Globals.currentShow {
      let currentShowType = theShow.affiliation
      var answer = [String]()
      if let currentBreeds = Breeds.breedsByGroupAndShowtype[currentShowType] {
        for (_, breeds) in currentBreeds {
          answer += breeds
        }
        return answer
      }
    }
      return []
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

}