//
//  Colours.swift
//  CatBase
//
//  Created by John Sandercock on 9/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

var coloursToken: dispatch_once_t = 0

class Colours: DataSource {
  
  static var entity = "Colours"
  static var list = DictOfStringArray()
  
  var currentBreed: String? = nil

   override class func initialize() {
    dispatch_once(&coloursToken) {
      list = dictFromPList(Colours.entity) as! DictOfStringArray
      print("  ***\nColours read in:")
      for (breed, _) in list {
        print("\(breed) ", appendNewline: false)
      }
      print("*****")
    }
  }
  
  override var list: [String] {
    if currentBreed != nil {
      return Colours.list[currentBreed!]!
    } else {
      return []
    }
  }
  
  @IBAction func newBreedChosen(sender: NSComboBox) {
    currentBreed = sender.stringValue
    print("Selected breed now: \(currentBreed)")
    let colours = list
    for colour in colours {
      print("\(colour) ", appendNewline: false)
    }
    print("****")
  }
  
}
