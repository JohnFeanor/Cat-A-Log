//
//  NameFormatter.swift
//  Formatting tester
//
//  Created by John Sandercock on 11/07/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

// let hypen = "-"
let space = " "
let apostrophy = "'"

let strLower = "[a-z]";
let strUpper = "[A-Z]"
let alpha = "[A-Z,a-z]"
let wordChar = "[A-Z,a-z,']"

let lowerCase = NSPredicate(format:"SELF MATCHES %@", strLower)
let upperCase = NSPredicate(format:"SELF MATCHES %@", strUpper)
let alphaCharacter = NSPredicate(format: "SELF MATCHES %@", alpha)
let breakCharacter = NSPredicate(format: "NOT SELF MATCHES %@", wordChar)
let wordCharacter = NSPredicate(format: "SELF MATCHES %@", wordChar)

class NameFormatter: NSFormatter {
  
  var exempted: NSArray = ["a", "da", "de", "vo", "von", "der"]
  
  override var description: String {
    get {
      return "Formatter exempting: \(self.exempted)"
    }
  }
  
  @IBOutlet var inField: NSTextField!
  
  var text: String = ""
  var list:[String] = []
  
  // MARK: - Convenience method to store completion strings
  
  func addToList(name: String) {
    let nList: NSArray = list as NSArray
    if !nList.containsObject(name) {
      list.append(name)
    }
  }
  
  // MARK: - Specific formatter methods
  
  func  firstKeyForPartialString(prefix: String?) -> String? {
    if let prefix = prefix {
      var currentChoice: String? = nil
      var lowercaseprefix = prefix.lowercaseString
      
      for string in list {
        if string.lowercaseString.hasPrefix(lowercaseprefix) {
          if currentChoice == nil {
            currentChoice = string
          } else if count(string) < count(currentChoice!) {
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
    var sentence = map(text, {String($0)})
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
    for x in stride(from: start, through: 0, by: -1) {
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
        lastWord.splice(letter, atIndex: lastWord.endIndex)
      } else {
        if letter == apostrophy {
          lastWord.splice(letter, atIndex: lastWord.endIndex)
        }
        break
      }
    }
    
    let endOfWord = breakCharacter.evaluateWithObject(sentence[endOfSentence])
    
    // Only capitalize a one letter word if we have reached an end-of-word
    if lengthOfWord == 1 {
      if endOfWord {
        if !exempted.containsObject(lastWord) {
          sentence[startOfWord] = sentence[startOfWord].uppercaseString
        }
      }
    } else {  // Otherwise capitalize them all
      if !exempted.containsObject(lastWord) {
        sentence[startOfWord] = sentence[startOfWord].uppercaseString
      }
    }
    return reduce(sentence, "", {$0 + $1})
  }
  
  // MARK: - general formatter methods that must be overwritten
  
  override func stringForObjectValue(obj: AnyObject) -> String? {
    // obj not thread-safe; can be nil
    return text
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
      partialStringCount = count(partialString)
    }
    
    var match = self.firstKeyForPartialString(partialString)
    
    if let match = match {
      
      // if this will not move the cursor forward, it is a delete
      if origSelRange.location == proposedSelRangePtr.memory.location {
        return true
      }
      
      // if the partial string is shorter than the match, set the selection
      let matchCount = count(match)
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
  
  override func controlTextDidChange(aNotification: NSNotification) {
    if let info: [NSObject : AnyObject] = aNotification.userInfo {
      if let myText = info["NSFieldEditor"] as? NSText{
        text = myText.string!
      }
    }
  }
  
  func control(control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
    text = control.stringValue
    return true
  }
  
  func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
    text = control.stringValue
    self.addToList(text)
    return true
  }
  
}
