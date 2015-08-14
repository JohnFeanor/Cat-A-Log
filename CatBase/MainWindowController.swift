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
  
  @IBOutlet weak var tableView: NSTableView!
  
  var managedObjectContext: NSManagedObjectContext!
  
  var addShowWindowController: AddShowWindowController? = nil
  var addEntryWindowController: EntrySheetController? = nil
    
  
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
  
  // ================================
  // MARK: - Undo methods
  // ================================
  
  override var undoManager: NSUndoManager {
    get {
      return self.managedObjectContext.undoManager!
    }
  }

  func windowWillReturnUndoManager(window: NSWindow) -> NSUndoManager? {
    // The undo menu item is only enabled if we return a undoManager here
    return self.undoManager
  }
  
  @IBAction func undo(sender: NSButton) {
    print("Undoing")
    undoManager.undo()
  }
  
  // ========================
  // MARK: - Methods
  // ========================

  func tableViewSelectionDidChange(aNotification: NSNotification) {
    if aNotification.object as? NSTableView == tableView {
      Globals.currentShow = theShowController.selectedObjects[0] as? Show
    }
  }
  
  // ========================
  // MARK: - Show IBActions
  // ========================
  
  @IBAction func addShow(sender: NSButton) {
    if let window = window {
      
      // Create and configure the window controller to present as a sheet:
      let sheetController = AddShowWindowController()
      print("\nStarting add show window sheet\n ****")
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSModalResponseOK {
          let newShow = Show(showData: self.addShowWindowController!.addShowDataSheet, insertIntoManagedObjectContext: self.managedObjectContext)
          print("created new show")
          self.theShowController.addObject(newShow)
          print("Added new show: \(newShow.name)")
        }
        // All done with the window controller
        self.addShowWindowController = nil
      })
      addShowWindowController = sheetController
    }
  }
  
  @IBAction func editShow(sender: NSButton) {
    if let window = window {
      let sheetController = AddShowWindowController()
      if Globals.currentShow != nil {
        print("   ***\nStarting editing show window sheet")
        sheetController.setToShow(show: Globals.currentShow!)
        window.beginSheet(sheetController.window!, completionHandler: { response in
          // The sheet has finished. Did the user click 'OK'?
          if response == NSModalResponseOK {
            Globals.currentShow!.setValuesTo(self.addShowWindowController!.addShowDataSheet)
          }
          // All done with the window controller
          self.addShowWindowController = nil
        })
        addShowWindowController = sheetController
      } else {
        print("trying to edit a nil show")
      }
    }
  }
  
  @IBAction func removeShow(sender: NSButton) {
    if areYouSure("Do you really want to delete this show?") {
      undoManager.beginUndoGrouping()
      undoManager.setActionName("remove show")
      theShowController.remove(sender)
      undoManager.endUndoGrouping()
    }
  }
  
  // ========================
  // MARK: - Entry IBActions
  // ========================
  
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
