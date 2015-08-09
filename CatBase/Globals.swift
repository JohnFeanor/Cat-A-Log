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

var currentShow: Show? = nil

var dataByGroup:[String : NSDictionary] = {
  return dictFromPList("ShowFormats") as! [String : NSDictionary]
}()

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
