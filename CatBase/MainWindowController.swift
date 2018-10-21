//
//  MainWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  let challenge    = NSLocalizedString("Challenge", tableName: "general", comment: "Challenge")
  let awardOfMerit  = NSLocalizedString("Award of Merit", tableName: "general", comment: "Award of merit")
  
  @IBOutlet var theShowController: NSArrayController!
  @IBOutlet var theEntriesController: NSArrayController!
  
  @IBOutlet weak var tableView: NSTableView!
  
  weak var appDelegate: AppDelegate!
  
  @objc var managedObjectContext: NSManagedObjectContext!
  
  var addShowWindowController: AddShowWindowController? = nil
  var addEntryWindowController: EntrySheetController? = nil
  
  var mainWindow: NSWindow? {
    return window
  }
    
  
  @objc dynamic var sortByDate = [NSSortDescriptor(key: "date", ascending: false)]
  @objc dynamic var sortByName = [NSSortDescriptor(key: "name", ascending: true)]
  @objc dynamic var sortByNameAndBreed  = [NSSortDescriptor(key: "breed", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
  
  override var windowNibName: NSNib.Name? {
    return NSNib.Name("MainWindowController")
  }
  
  // ================================
  // MARK: - Methods
  // ================================
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Show.nomen)
    
    let results = try! managedObjectContext.fetch(fetchRequest) as! [Show]
    for object in results {
      theShowController.addObject(object)
    }
    theShowController.rearrangeObjects()
    
    let centre = NotificationCenter.default
    centre.addObserver(self, selector: #selector(NSTableViewDelegate.tableViewSelectionDidChange(_:)), name: NSTableView.selectionDidChangeNotification, object: tableView)
  }
  
  @objc func tableViewSelectionDidChange(_ aNotification: Notification) {
    if Globals.currentShowName.isEmpty {
      appDelegate.writeMenuTitle = "No show selected"
      appDelegate.writeMenuAvailable = false
    } else {
      appDelegate.writeMenuTitle = "Write \(Globals.currentShowName) ..."
      appDelegate.writeMenuAvailable = true
    }
  }
  
  // ================================
  // MARK: - Undo methods
  // ================================
  
  @objc var myUndoManager: UndoManager {
    get {
      if let mum = self.managedObjectContext.undoManager {
        return mum
      } else {
        self.managedObjectContext.undoManager = UndoManager()
        return self.managedObjectContext.undoManager!
      }
    }
  }

  @objc func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager {
    // The undo menu item is only enabled if we return a undoManager here
    return self.myUndoManager
  }
  
  @IBAction func undo(_ sender: NSButton) {
    myUndoManager.undo()
  }
  
  // ========================
  // MARK: - Show IBActions
  // ========================
  
  @IBAction func addShow(_ sender: NSButton) {
    if let window = window {
      
      // Create and configure the window controller to present as a sheet:
      let sheetController = AddShowWindowController()
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSApplication.ModalResponse.OK {
          self.myUndoManager.beginUndoGrouping()
          self.myUndoManager.setActionName("add show")
          let newShow = Show(showData: self.addShowWindowController!.showData, insertIntoManagedObjectContext: self.managedObjectContext)
          self.theShowController.addObject(newShow)
          self.myUndoManager.endUndoGrouping()
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
  
  @IBAction func editShow(_ sender: NSButton) {
    if let window = window {
      let sheetController = AddShowWindowController()
      if Globals.currentShow != nil {
        speaker.startSpeaking("Editing \(Globals.currentShowName)")
        sheetController.setToShow(show: Globals.currentShow!)
        window.beginSheet(sheetController.window!, completionHandler: { response in
          // The sheet has finished. Did the user click 'OK'?
          if response == NSApplication.ModalResponse.OK {
            self.myUndoManager.beginUndoGrouping()
            self.myUndoManager.setActionName("edit show")
            Globals.currentShow!.setValuesTo(self.addShowWindowController!.showData)
            self.myUndoManager.endUndoGrouping()
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
  
  @IBAction func removeShow(_ sender: NSButton) {
    if areYouSure("Do you really want to delete the \(Globals.currentShow!.name) show?") {
      myUndoManager.beginUndoGrouping()
      myUndoManager.setActionName("remove show")
      theShowController.remove(sender)
      myUndoManager.endUndoGrouping()
      do { try self.managedObjectContext.save() }
      catch{
        print("Error trying to save managed object context after removal of show")
      }
    }
  }
  
  // ========================
  // MARK: - Entry IBActions
  // ========================
  
  @IBAction func addEntry(_ sender: NSButton) {
    if let window = window {
      
      if Globals.currentShow == nil {
        print("Trying to add entry when current show is nil")
        return
      }
      let sheetController = EntrySheetController()
      assert(self.managedObjectContext != nil)
      sheetController.managedObjectContext = self.managedObjectContext
      speaker.startSpeaking("adding an entry")
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSApplication.ModalResponse.OK {
          
          // check to make sure this cat is not already in the show
          var problem = false
          if let name = sheetController.entryData[Cat.name] as? String, let entries = Globals.currentShow?.entries {
            var duplicate = false
            for entry in entries {
              guard let entry = entry as? Entry
                else { break }
              if entry.cat.name == name {
                duplicate = true
                break
              }
            }
            if duplicate {
              problem = !areYouSure("\(name) is already in the catalogue.\nDo you really want to add \(name) again?")
            }
          }
          
          if !problem {
            self.myUndoManager.beginUndoGrouping()
            self.myUndoManager.setActionName("add entry")
            let newEntry = Entry(entryData: sheetController.entryData, insertIntoManagedObjectContext: self.managedObjectContext)
            self.theEntriesController.addObject(newEntry)
            self.theEntriesController.rearrangeObjects()
            self.myUndoManager.endUndoGrouping()
          }
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
  
  @IBAction func removeEntry(_ sender: NSButton) {
    let name = Globals.currentEntry!.cat.name
    if areYouSure("Do you really want to delete \(name)?") {
      myUndoManager.beginUndoGrouping()
      myUndoManager.setActionName("remove entry")
      theEntriesController.remove(sender)
      myUndoManager.endUndoGrouping()
      do { try self.managedObjectContext.save() }
      catch{
        print("Error trying to save managed object context after removal of entry")
      }
    }
  }
  
  @IBAction func editEntry(_ sender: NSObject) {
    if let window = window {
      
      if Globals.currentEntry == nil {
        print("Trying to edit entry when current entry is nil")
        return
      }
      let sheetController = EntrySheetController()
      sheetController.managedObjectContext = self.managedObjectContext
      sheetController.setSheetTo(Globals.currentEntry!)
      sheetController.dateSet = true
      speaker.startSpeaking("editing \(Globals.currentEntry!.cat.name)")
      window.beginSheet(sheetController.window!, completionHandler: { response in
        // The sheet has finished. Did the user click 'OK'?
        if response == NSApplication.ModalResponse.OK {
          self.myUndoManager.beginUndoGrouping()
          self.myUndoManager.setActionName("edit entry")
          if Globals.currentEntry == nil {
            print("current entry has become nil while editing it")
          }
          Globals.currentEntry?.updateTo(self.addEntryWindowController!.entryData)
          self.theEntriesController.rearrangeObjects()
          self.myUndoManager.endUndoGrouping()
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
  
  // *****************************
  // MARK: - Write out catalogue
  // *****************************
  
  @objc func displaySavePanel() {
    let savePanel = NSSavePanel()
    savePanel.allowedFileTypes = ["rtf"]
    savePanel.isExtensionHidden = false
    savePanel.canSelectHiddenExtension = false
    savePanel.nameFieldStringValue = "\(Globals.currentShowName).rtf"
    
    savePanel.beginSheetModal(for: window!, completionHandler: {
      [unowned savePanel] (result) in
      if result == NSApplication.ModalResponse.OK {
        self.printCatalog(savePanel.nameFieldStringValue, to: savePanel.url!)
      }
    })
  }
  
}
