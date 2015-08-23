//
//  MyComboBox.swift
//  CatBase
//
//  Created by John Sandercock on 21/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class MyComboBox: NSComboBox, BreedSelector {

  var currentBreed: String {
    return self.stringValue
  }
  
}
