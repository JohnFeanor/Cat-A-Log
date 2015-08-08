//
//  MainWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  @IBOutlet var theShowController: NSArrayController!
  var managedObjectContext: NSManagedObjectContext!
  
  var addShowWindowController: AddShowWindowController? = nil
  var addEntryWindowController: EntrySheetController? = nil
  dynamic var currentShows = [Show]() {
    didSet {
      print("currentShows changed to \(currentShows)")
    }
  }
  var currentShow: Show? = nil
    
  
  dynamic var sortByDate = [NSSortDescriptor(key: "date", ascending: false)]
  dynamic var sortByName = [NSSortDescriptor(key: "name", ascending: true)]
  
  override var windowNibName: String {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    
    let fetchRequest = NSFetchRequest(entityName: Show.entity)
    var error: NSError? = nil
    
    let numberOfShows = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
    if numberOfShows < 1 {
      print("no shows in database")
      return
    } else {
      print("There are \(numberOfShows) shows in the database")
    }
    let results = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Show]
    
    for object in results {
      theShowController.addObject(object)
    }
    theShowController.rearrangeObjects()
  }
  
  // MARK: - Show IBActions
  
  @IBAction func changeShow(sender: NSButton) {
    print("change show button clicked")

    if let window = window {
      
      // Create and configure the window controller to present as a sheet:
      let sheetController = AddShowWindowController()
      // get the current selected show
      currentShow = theShowController.selectedObjects[0] as? Show
      // prepopulate our sheet with the current show's values
      sheetController.setDataTo(currentShow!.dictionary())
      print("Starting edit show window sheet")
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSModalResponseOK {
          print("edited show")
          self.currentShow!.setValuesTo(self.addShowWindowController!.asDictionary)
        }
        // All done with the window controller
        self.addShowWindowController = nil
        self.currentShow = nil
      })
      addShowWindowController = sheetController
    }
    
  }
  
  @IBAction func addShow(sender: NSButton) {
    if let window = window {
      
      // Create and configure the window controller to present as a sheet:
      let sheetController = AddShowWindowController()
      print("Starting add show window sheet")
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSModalResponseOK {
          let newShow = Show(showData: self.addShowWindowController!.asDictionary, insertIntoManagedObjectContext: self.managedObjectContext)
          print("created new show")
          self.theShowController.addObject(newShow)
          print("Added new cat: \(newShow.name)")
        }
        // All done with the window controller
        self.addShowWindowController = nil
      })
      addShowWindowController = sheetController
    }
  }
  
  @IBAction func editShow(sender: NSButton) {
    if let window = window {
      let currentShow = theShowController.selectedObjects[0] as! Show
      
    }
  }
  
  // MARK: - Entry IBActions
  
  @IBAction func addEntry(sender: NSButton) {
    if let window = window {
      
      let sheetController = EntrySheetController()
      print("Starting add entry sheet")
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSModalResponseOK {
          print("create a new entry here")
        }
        self.addEntryWindowController = nil
      })
      addEntryWindowController = sheetController
    }
  }
  
  
  @IBAction func editEntry(sender: NSButton) {
  }
  
}
