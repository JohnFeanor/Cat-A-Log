//
//  MyTableView.swift
//  CatBase
//
//  Created by John Sandercock on 21/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class MyTableView: NSTableView, BreedSelector {

  var currentBreed: String {
    let row = self.selectedRow
    let breeds = self.dataSource()
    if let breeds = breeds {
      let ans = breeds.tableView!(self, objectValueForTableColumn:nil, row: row)
      let final = ans as? String
      if final != nil {
        return final!
      }
    }
    return ""
  }
  
}
