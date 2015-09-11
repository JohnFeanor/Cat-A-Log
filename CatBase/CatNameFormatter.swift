//
//  CatNameFormatter.swift
//  CatBase
//
//  Created by John Sandercock on 11/09/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Foundation

class CatNameFormatter: NameFormatter {
  
  let uppercase = ["nz", "Nz", "Usa", "uk", "Uk"]

  override var list:[String] {
    return CatNameFormatter.list
  }
  
  override func addToList(name: String) {
    if !CatNameFormatter.list.contains(name) {
      CatNameFormatter.list.append(name)
      let parts = name.componentsSeparatedByString(" ")
      if parts.count > 1 {
        CatNameFormatter.list.append(parts[0] + " ")
      }
    }
  }
  
  override func capitalize(word: String, preceding: String?, following: String?) -> Action {
    
    if !exempted.contains(word) {
      // Words with more than one letter get capitalized
      if word.characters.count > 1 {
        if !uppercase.contains(word) {
          return .capitalize
        } else {
          if following != nil && breakCharacter.evaluateWithObject(following!) {
            return .uppercase
          }
          return .capitalize
        }
      }
      
      // First letter in a sentence gets capitalized
      if preceding == nil { return .capitalize }
      
      // Last letter in a partial sentence does not get capitalized
      if following == nil { return .leave }
      
      // Otherwise capitalize a one letter word unless it is a special case
      if preceding! != "'" {
        return .capitalize
      }
    }
    return .leave
  }

}