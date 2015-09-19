//
//  NameFormatter.swift
//  Formatting tester
//
//  Created by John Sandercock on 11/07/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

class NameFormatter: NSFormatter {
  
  enum Action {
    case leave
    case capitalize
    case uppercase
  }
  
  static var list: [String] = []
  
  let exempted = ["a", "da", "de", "of", "vo", "von", "der", "th", "the"]
  
  override var description: String {
    get {
      return "Formatter exempting: \(self.exempted)"
    }
  }
  
  var list:[String] {
    return NameFormatter.list
  }
  
  @IBOutlet var inField: NSTextField!
  
  // MARK: - Convenience method to store completion strings
  
  func addToList(name: String) {
    if !NameFormatter.list.contains(name) {
      NameFormatter.list.append(name)
    }
  }
  
  // MARK: - Specific formatter methods
  
  func  firstKeyForPartialString(prefix: String?) -> String? {
    if let prefix = prefix {
      var currentChoice: String? = nil
      let lowercaseprefix = prefix.lowercaseString
      for string in list {
        if string.lowercaseString.hasPrefix(lowercaseprefix) {
          if currentChoice == nil {
            currentChoice = string
          } else if string.characters.count < (currentChoice!).characters.count {
            currentChoice = string
          }
        }
      }
      return currentChoice
    } else {
      return nil
    }
  }
  
  private func titleCase(text: String) -> String {
    
    if text.isEmpty {
      return text
    }
    var sentence = text.characters.map({String($0)})
    let sentenceLength = sentence.count
    
    // Capitialize the first letter of a sentence
    if sentenceLength == 1 {
      sentence[0] = sentence[0].uppercaseString
      return sentence[0]
    }
    
    // Find the beginning of last word typed in
    var startOfWord = 0
    var lengthOfWord = 0
    let endOfSentence = sentenceLength - 1
    let start = wordCharacter.evaluateWithObject(sentence[endOfSentence]) ? endOfSentence : endOfSentence - 1
    for x in start.stride(through: 0, by: -1) {
      let letter = sentence[x]
      if alphaCharacter.evaluateWithObject(letter) || x == start {
        lengthOfWord++
      } else {
        startOfWord = x + 1
        break
      }
    }
    
    // get that last word
    var lastWord = ""
    startOfWord = startOfWord > endOfSentence ? endOfSentence : startOfWord
    for x in startOfWord ... endOfSentence {
      let letter = sentence[x]
      if alphaCharacter.evaluateWithObject(letter) {
        lastWord += letter
      } else {
        if letter == apostrophy {
          lastWord += letter
        }
        break
      }
    }
    
    // does it need capitalization?
    let preceding: String? = startOfWord > 0 ? sentence[startOfWord - 1] : nil
    let last = startOfWord + lengthOfWord
    let following: String? = last >= sentenceLength ? nil : sentence[last]
    switch capitalize(lastWord, preceding: preceding, following: following) {
    case .capitalize:
      sentence[startOfWord] = sentence[startOfWord].uppercaseString
    case .uppercase:
      for i in startOfWord ..< last {
        sentence[i] = sentence[i].uppercaseString
      }
    default:
      break
    }

    return sentence.reduce("", combine: {$0 + $1})
  }
  
  func capitalize(word: String, preceding: String?, following: String?) -> Action {
    
    if !exempted.contains(word) {
      // Words with more than one letter get capitalized
      if word.characters.count > 1 {
        return .capitalize
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

  
  // MARK: - general formatter methods that must be overwritten
  
  override func stringForObjectValue(obj: AnyObject?) -> String? {
    // watch out for obj being nil
    if obj == nil {
      return nil
    }
    return obj as? String
  }
  
  override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
    obj.memory = string
    return true
  }
  
  override func isPartialStringValid(partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString?>, proposedSelectedRange proposedSelRangePtr: NSRangePointer, originalString origString: String, originalSelectedRange origSelRange: NSRange, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
    
    // allow deletes
    if (origSelRange.location == proposedSelRangePtr.memory.location) {
      return true
    }
    
    var partialString = ""
    var partialStringCount = 0
    if partialStringPtr.memory != nil {
      partialString = partialStringPtr.memory! as String
      partialStringCount = partialString.characters.count
    }
    
    let match = self.firstKeyForPartialString(partialString)
    
    if let match = match {
      
      // if this will not move the cursor forward, it is a delete
      if origSelRange.location == proposedSelRangePtr.memory.location {
        return true
      }
      
      // if the partial string is shorter than the match, set the selection
      let matchCount = match.characters.count
      if matchCount != partialStringCount {
        proposedSelRangePtr.memory.length = matchCount - partialStringCount
        partialStringPtr.memory = match
        return false
      }
      return true
    } else {
      // no match, so title case it and return false
      let p = titleCase(partialString)
      partialStringPtr.memory = p
      return false
    }
  }
  
  // MARK: - TextField delegate methods
  
  func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
    let text = control.stringValue
    self.addToList(text)
    return true
  }
  
}
