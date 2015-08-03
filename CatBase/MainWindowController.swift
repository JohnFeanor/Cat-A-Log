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
  var currentShow: Show? = nil
  
  dynamic let sectionNames = Breeds.sectionNames
  
  
  dynamic var sortByDate = [NSSortDescriptor(key: "date", ascending: false)]
  
  override var windowNibName: String {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    
    let fetchRequest = NSFetchRequest(entityName: Show.entity)
    var error: NSError? = nil
    
    let numberOfShows = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
    if numberOfShows < 1 {
      println("no shows in database")
      return
    } else {
      println("There are \(numberOfShows) shows in the database")
    }
    let results = managedObjectContext.executeFetchRequest(fetchRequest,
      error: &error) as! [Show]?
    
    if let results = results {
      for object in results {
        theShowController.addObject(object)
      }
    }
    theShowController.rearrangeObjects()
  }
  
  // MARK: - Show IBActions
  
  @IBAction func changeShow(sender: NSButton) {
    println("change show button clicked")

    if let window = window {
      
      // Create and configure the window controller to present as a sheet:
      let sheetController = AddShowWindowController()
      // get the current selected show
      currentShow = theShowController.selectedObjects[0] as? Show
      // prepopulate our sheet with the current show's values
      sheetController.setDataTo(currentShow!.dictionary())
      println("Starting edit show window sheet")
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSModalResponseOK {
          println("edited show")
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
      println("Starting add show window sheet")
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSModalResponseOK {
          let newShow = Show(showData: self.addShowWindowController!.asDictionary, insertIntoManagedObjectContext: self.managedObjectContext)
          println("created new show")
          self.theShowController.addObject(newShow)
          println("Added new cat: \(newShow.name)")
        }
        // All done with the window controller
        self.addShowWindowController = nil
      })
      addShowWindowController = sheetController
    }
  }
  
  // MARK: - Entry IBActions
  
  @IBAction func addEntry(sender: NSButton) {
    if let window = window {
      
      let sheetController = EntrySheetController()
      println("Starting add entry sheet")
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSModalResponseOK {
          println("create a new entry here")
        }
        self.addEntryWindowController = nil
      })
      addEntryWindowController = sheetController
    }
  }
  
  
  @IBAction func editEntry(sender: NSButton) {
  }
  
}
