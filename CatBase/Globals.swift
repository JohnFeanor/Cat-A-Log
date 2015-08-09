//
//  Globals.swift
//  CatBase
//
//  Created by John Sandercock on 4/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

typealias DictOfStringArray = [String : [String]]


let months = "Months"
let weeks = "Weeks"
let speaker = NSSpeechSynthesizer()

func dictFromPList(listName: String) -> NSDictionary {
  let path = NSBundle.mainBundle().pathForResource(listName, ofType:"plist")
  if let path = path {
    print("Reading plist from: \(path)")
    return NSDictionary(contentsOfFile:path)!
  } else {
    fatalError("Cannot load internal data \(listName)")
  }
}

func errorAlert(message message: String) {
  let alert = NSAlert()
  alert.addButtonWithTitle("OK")
  alert.messageText = message
  alert.alertStyle = .WarningAlertStyle
  speaker.startSpeakingString("Excuse me, \(message)")
  alert.runModal()
}

class Globals: NSObject {
  
  static var currentShow: Show? = nil
  
  static var dataByGroup:[String : NSDictionary] = {
    return dictFromPList("ShowFormats") as! [String : NSDictionary]
    }()
  
  static var showTypes: [String] = {
    let allKeys = dataByGroup.keys.array
    return allKeys.sort(>)
  }()
  
  dynamic var showTypes: [String] {
    return Globals.showTypes
  }
}
