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
  
  // breedSource must be bound to a control which will return a valid breed name
  @IBOutlet weak var breedSource: NSControl!
  
  var currentBreed: String? {
    // this may be called before the binding is set up
    return breedSource?.stringValue
  }

   override class func initialize() {
    dispatch_once(&coloursToken) {
      list = dictFromPList(Colours.entity) as! DictOfStringArray
    }
  }
  
  override var list: [String] {
    if currentBreed != nil {
      return Colours.list[currentBreed!]!
    } else {
      return []
    }
  }
  
}
