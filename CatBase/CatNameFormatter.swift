//
//  CatNameFormatter.swift
//  CatBase
//
//  Created by John Sandercock on 11/09/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Foundation

class CatNameFormatter: NameFormatter {
  
  static var catList: [String] = []
  
  let uppercase = ["nz", "Nz", "Usa", "uk", "Uk"]
  
  override var exempted: [String] {
    return ["a", "da", "de", "of", "vo", "von", "der", "th", "the"]
  }

  override var list:[String] {
    return CatNameFormatter.catList
  }
  
  override func addToList(_ name: String) {
    if !CatNameFormatter.catList.contains(name) {
      CatNameFormatter.catList.append(name)
      let parts = name.components(separatedBy: " ")
      if parts.count > 1 && !CatNameFormatter.catList.contains(parts[0] + " "){
        CatNameFormatter.catList.append(parts[0] + " ")
      }
    }
  }
  
  override func capitalize(_ word: String, preceding: String?, following: String?) -> Action {
    
    if exempted.contains(word) { return .leave }
    
    // Words with more than one letter get capitalized
    if word.characters.count > 1 {
      if uppercase.contains(word) {
        if following != nil && breakCharacter.evaluate(with: following!) {
          // if they are an ancronym for a country they get fully uppercased
          return .uppercase
        }
      }
      return .capitalize
    }
    
    // First letter in a sentence gets capitalized
    if preceding == nil { return .capitalize }
    
    // Last letter in a partial sentence does not get capitalized
    if following == nil { return .leave }
    
    // Otherwise capitalize a one letter word unless it is a special case
    if preceding! != "'" { return .capitalize }
    return .leave
  }

}
