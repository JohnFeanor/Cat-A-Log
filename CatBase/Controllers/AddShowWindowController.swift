//
//  AddShowWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

class AddShowWindowController: NSWindowController {
  
  @IBOutlet weak var nameTextField: NSTextField!
  @IBOutlet weak var LhJudge2: NSTextField!
  @IBOutlet weak var ShJudge2: NSTextField!
  @IBOutlet weak var LhJudge3: NSTextField!
  @IBOutlet weak var ShJudge3: NSTextField!
  @IBOutlet weak var LhJudge4: NSTextField!
  @IBOutlet weak var ShJudge4: NSTextField!
  @IBOutlet weak var LhJudge5: NSTextField!
  @IBOutlet weak var ShJudge5: NSTextField!
  @IBOutlet weak var LhJudge6: NSTextField!
  @IBOutlet weak var ShJudge6: NSTextField!
  
  var judgesNames:[[NSTextField]] = []
  
  @objc var showData: [String : AnyObject]  {
    return self.dictionaryWithValues(forKeys: Show.properties) as [String : AnyObject]
  }
  
  override var windowNibName: NSNib.Name? {
    return NSNib.Name("AddShowWindowController")
  }
  
  // MARK: - show properties
  
  @objc fileprivate dynamic var affiliation: String = "QFA Show"
  @objc fileprivate dynamic var name: String = "New Show"
  
  @objc fileprivate dynamic var date: Date = Date()
  
  @objc fileprivate dynamic var judgeLH1: String = ""
  @objc fileprivate dynamic var judgeLH2: String = ""
  @objc fileprivate dynamic var judgeLH3: String = ""
  @objc fileprivate dynamic var judgeLH4: String = ""
  @objc fileprivate dynamic var judgeLH5: String = ""
  @objc fileprivate dynamic var judgeLH6: String = ""
  
  @objc fileprivate dynamic var judgeSH1: String = ""
  @objc fileprivate dynamic var judgeSH2: String = ""
  @objc fileprivate dynamic var judgeSH3: String = ""
  @objc fileprivate dynamic var judgeSH4: String = ""
  @objc fileprivate dynamic var judgeSH5: String = ""
  @objc fileprivate dynamic var judgeSH6: String = ""
  
  @objc fileprivate dynamic var numberOfRings = 3 {
    didSet {
      var count: Int = 1
      
      for judges in judgesNames {
        judges[0].isEnabled = numberOfRings > count
        judges[1].isEnabled = numberOfRings > count
        count += 1
      }
    }
  }
  

  // ====================
  // MARK: - Methods
  // ====================
  
  override func windowDidLoad() {
    super.windowDidLoad()
    judgesNames = [[LhJudge2, ShJudge2], [LhJudge3, ShJudge3], [LhJudge4, ShJudge4], [LhJudge5, ShJudge5], [LhJudge6, ShJudge6]]

    // reinitalise the number of shows to enable the proper judges name textfields
    let n = numberOfRings
    numberOfRings = n
  }
  
  // initialize the sheet to an existing Show
    @objc func setToShow(show: Show) {
    for property in Show.properties {
      self.setValue(show.value(forKey: property), forKey: property)
    }
    self.window!.makeFirstResponder(self.nameTextField)
  }
  
  // ====================
  // MARK: - IBActions
  // ====================

  
  @IBAction func okButtonPressed(_ sender: NSButton) {
    window?.endEditing(for: nil)

    dismissWithModalResponse(NSApplication.ModalResponse.OK)
  }
  
  
  @IBAction func cancelButtonPressed(_ sender: NSButton) {
    dismissWithModalResponse(NSApplication.ModalResponse.cancel)
  }
  
  @objc func dismissWithModalResponse(_ response: NSApplication.ModalResponse)
  {
    window!.sheetParent!.endSheet(window!, returnCode: response)
  }
}

