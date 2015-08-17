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
  @IBOutlet var theEntriesController: NSArrayController!
  
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
    undoManager.undo()
  }
  
  // ========================
  // MARK: - Methods
  // ========================

  func tableViewSelectionDidChange(aNotification: NSNotification) {
    Globals.currentShow = theShowController.selectedObjects?.first as? Show
    Globals.currentEntry = theEntriesController.selectedObjects?.first as? Entry
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
          self.undoManager.beginUndoGrouping()
          self.undoManager.setActionName("add show")
          let newShow = Show(showData: self.addShowWindowController!.showData, insertIntoManagedObjectContext: self.managedObjectContext)
          self.theShowController.addObject(newShow)
          self.undoManager.endUndoGrouping()
          do { try self.managedObjectContext.save() }
          catch{
            print("Error trying to save managed object context after adding of show")
          }
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
        sheetController.setToShow(show: Globals.currentShow!)
        window.beginSheet(sheetController.window!, completionHandler: { response in
          // The sheet has finished. Did the user click 'OK'?
          if response == NSModalResponseOK {
            self.undoManager.beginUndoGrouping()
            self.undoManager.setActionName("edit show")
            Globals.currentShow!.setValuesTo(self.addShowWindowController!.showData)
            self.undoManager.endUndoGrouping()
          }
          // all done with the entry sheet controller
          self.addShowWindowController = nil
          do { try self.managedObjectContext.save() }
          catch{
            print("Error trying to save managed object context after edit of show")
          }
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
      do { try self.managedObjectContext.save() }
      catch{
        print("Error trying to save managed object context after removal of show")
      }
    }
  }
  
  // ========================
  // MARK: - Entry IBActions
  // ========================
  
  @IBAction func addEntry(sender: NSButton) {
    if let window = window {
      
      if Globals.currentShow == nil {
        print("Trying to add entry when current show is nil")
        return
      }
      let sheetController = EntrySheetController()
      sheetController.managedObjectContext = self.managedObjectContext
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSModalResponseOK {
          self.undoManager.beginUndoGrouping()
          self.undoManager.setActionName("add entry")
          let newEntry = Entry(entryData: sheetController.entryData, insertIntoManagedObjectContext: self.managedObjectContext)
          self.theEntriesController.addObject(newEntry)
          self.theEntriesController.rearrangeObjects()
          self.undoManager.endUndoGrouping()
        }
        // all done with the entry sheet controller
        self.addEntryWindowController = nil
        do { try self.managedObjectContext.save() }
        catch{
          print("Error trying to save managed object context after adding of entry")
        }
      })
      addEntryWindowController = sheetController
    }
  }
  
  @IBAction func removeEntry(sender: NSButton) {
    if areYouSure("Do you really want to delete this entry?") {
      undoManager.beginUndoGrouping()
      undoManager.setActionName("remove entry")
      theEntriesController.remove(sender)
      undoManager.endUndoGrouping()
      do { try self.managedObjectContext.save() }
      catch{
        print("Error trying to save managed object context after removal of entry")
      }
    }
  }
  
  @IBAction func editEntry(sender: NSObject) {
    if let window = window {
      
      if Globals.currentEntry == nil {
        print("Trying to edit entry when current entry is nil")
        return
      }
      let sheetController = EntrySheetController()
      sheetController.managedObjectContext = self.managedObjectContext
      sheetController.setSheetTo(Globals.currentEntry!)
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSModalResponseOK {
          self.undoManager.beginUndoGrouping()
          self.undoManager.setActionName("edit entry")
          if Globals.currentEntry == nil {
            print("current entry has become nil while editing it")
          }
          Globals.currentEntry?.updateTo(self.addEntryWindowController!.entryData)
          self.theEntriesController.rearrangeObjects()
          self.undoManager.endUndoGrouping()
        }
        // all done with the entry sheet controller
        self.addEntryWindowController = nil
        do { try self.managedObjectContext.save() }
        catch{
          print("Error trying to save managed object context after edit of entry")
        }
      })
      addEntryWindowController = sheetController
    }
  }
  
}
