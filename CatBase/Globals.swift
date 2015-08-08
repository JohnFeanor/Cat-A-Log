//
//  Globals.swift
//  CatBase
//
//  Created by John Sandercock on 4/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Foundation

typealias DictOfStringArray = [String : [String]]

var dataByGroup:[String : NSDictionary]! = nil

func dictFromPList(listName: String) -> [String : NSDictionary] {
  let path = NSBundle.mainBundle().pathForResource(listName, ofType:"plist")
  if let path = path {
    print("Reading plist from: \(path)")
    return NSDictionary(contentsOfFile:path) as! [String : NSDictionary]
  } else {
    fatalError("Cannot load internal data \(listName)")
  }
}

func loadPListData() {
  if dataByGroup == nil {
    dataByGroup = dictFromPList("ShowFormats")
  }
}
