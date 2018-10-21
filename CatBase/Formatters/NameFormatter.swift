//
//  NameFormatter.swift
//  Formatting tester
//
//  Created by John Sandercock on 11/07/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

private extension Character {
  var bannedChar: Bool {
    switch self {
    case ("\0" ..< " "):
      return true
    default:
      return false
    }
  }
}

class NameFormatter: Formatter, NSControlTextEditingDelegate {
  
  enum Action {
    case leave
    case capitalize
    case uppercase
  }
  
  static var list: [String] = []
  
  var exempted: [String] {
    return ["da", "de", "of", "vo", "von", "der", "th", "the"]
  }
  
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
  
  func addToList(_ name: String) {
    if !NameFormatter.list.contains(name) {
      NameFormatter.list.append(name)
    }
  }
  
  // MARK: - Specific formatter methods
  
  func  firstKeyForPartialString(_ prefix: String?) -> String? {
    if let prefix = prefix {
      var currentChoice: String? = nil
      let lowercaseprefix = prefix.lowercased()
      for string in list {
        if string.lowercased().hasPrefix(lowercaseprefix) {
          if currentChoice == nil {
            currentChoice = string
          } else if string.count < (currentChoice!).count {
            currentChoice = string
          }
        }
      }
      return currentChoice
    } else {
      return nil
    }
  }
  
  fileprivate func titleCase(_ text: String) -> String {
    
    if text.isEmpty {
      return text
    }
    var sentence = text.map({String($0)})
    let sentenceLength = sentence.count
    
    // Capitialize the first letter of a sentence
    if sentenceLength == 1 {
      sentence[0] = sentence[0].uppercased()
      return sentence[0]
    }
    
    // Find the beginning of last word typed in
    var startOfWord = 0
    var lengthOfWord = 0
    let endOfSentence = sentenceLength - 1
    let start = wordCharacter.evaluate(with: sentence[endOfSentence]) ? endOfSentence : endOfSentence - 1
    for x in stride(from: start, through: 0, by: -1) {
      let letter = sentence[x]
      if alphaCharacter.evaluate(with: letter) || x == start {
        lengthOfWord += 1
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
      if alphaCharacter.evaluate(with: letter) {
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
      sentence[startOfWord] = sentence[startOfWord].uppercased()
    case .uppercase:
      for i in startOfWord ..< last {
        sentence[i] = sentence[i].uppercased()
      }
    default:
      break
    }

    return sentence.reduce("", {$0 + $1})
  }
  
  func capitalize(_ word: String, preceding: String?, following: String?) -> Action {
    
    if !exempted.contains(word) {
      // Words with more than one letter get capitalized
      if word.count > 1 {
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
  
  override func string(for obj: Any?) -> String? {
    // watch out for obj being nil
    if obj == nil {
      return nil
    }
    return obj as? String
  }
  
  override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
    obj?.pointee = string as AnyObject?
    return true
  }
  
  override func isPartialStringValid(_ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>, proposedSelectedRange proposedSelRangePtr: NSRangePointer?, originalString origString: String, originalSelectedRange origSelRange: NSRange, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
    
    // allow deletes
    if (origSelRange.location == proposedSelRangePtr?.pointee.location) {
      return true
    }
    
    var partialString = ""
    var partialStringCount = 0
    partialString = partialStringPtr.pointee as String
    partialStringCount = partialString.count
    
    if let ch = partialString.last , ch.bannedChar { return false }
    
    let match = self.firstKeyForPartialString(partialString)
    
    if let match = match {
      
      // if this will not move the cursor forward, it is a delete
      if origSelRange.location == proposedSelRangePtr?.pointee.location {
        return true
      }
      
      // if the partial string is shorter than the match, set the selection
      let matchCount = match.count
      if matchCount != partialStringCount {
        proposedSelRangePtr?.pointee.length = matchCount - partialStringCount
        partialStringPtr.pointee = match as NSString
        return false
      }
      return true
    } else {
      // no match, so title case it and return false
      let p = titleCase(partialString)
      partialStringPtr.pointee = p as NSString
      return false
    }
  }
  
  // MARK: - TextField delegate methods
  
  func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
    let text = control.stringValue
    self.addToList(text)
    return true
  }
  
}
