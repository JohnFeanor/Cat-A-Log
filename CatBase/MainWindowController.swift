//
//  MainWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  let nbspace        = "&nbsp;".data
  
  let  headerPt2     = readFile("headerPt2")
  let  header1       = readFile("Header1")
  let  header2       = readFile("Header2")
  let  header2judge  = readFile("Header2judge")
  let  tableStart    = readFile("Table start")
  let  tableEnd      = readFile("Table end")
  let  rowEnd        = "</tr>".data
  
  let  section1      = readFile("Section1")
  let  section2      = readFile("Section2")
  let  breed1        = readFile("Breed1")
  let  breed2        = readFile("Breed2")
  let  colour1       = readFile("Colour1")
  let  colour2       = readFile("Colour2")
  let  colour3       = readFile("Colour3")
  let  name1         = readFile("Name1")
  let  name1Litter   = readFile("Name1 litter")
  let  name2         = readFile("Name2")
  let  name2Litter   = readFile("Name2 litter")
  let  name3         = readFile("Name3")
  let  name4         = readFile("Name4")
  let  details1      = readFile("Details1")
  let  details1Litter = readFile("Details1 Litter")
  let  details2      = readFile("Details2")
  let  details3      = readFile("Details3")
  let  details3Litter = readFile("Details3Litter")
  let  details4      = readFile("Details4")
  let  details5      = readFile("Details5")
  let  challenge1    = readFile("Challenge1")
  let  challenge2    = readFile("Challenge2")
  let  challenge3    = readFile("Challenge3")
  let  prestige1     = readFile("Prestige1")
  let  bestAward1    = readFile("BestAward1")
  let  bestAward2    = readFile("BestAward2")
  let  bestAward3    = readFile("BestAward3")
  let  bestAward4    = readFile("BestAward4")
  let  entered       = readFile("Box entered")
  let  notEntered    = readFile("Box not entered")
  let  underlined    = readFile("Box underlined")
  let  noRing        = readFile("Box no ring")
  let  endOfEntries      = readFile("EndOfEntries")
  let  bestOfBreedStart  = readFile("BestOfBreedStart")
  let  bestOfBreedEnd    = readFile("BestOfBreedEnd")
  let  spacer            = readFile("Spacer")
  
  let  ACFstartTable     = readFile("ACFAward start table")
  let  ACFstartRow       = readFile("ACFAward start row")
  let  ACFendRow         = readFile("ACFAward end row")
  
  let  ACFAoEstart       = readFile("ACFAoE start")
  let  ACFAoEstartRow    = readFile("ACFAoE start row")
  let  ACFAoEendRow      = readFile("ACFAoE end row")
  
  let  topTenStartTable  = readFile("Top ten start table")
  let  topTenEndTable    = readFile("Top ten end table")
  
  let  endOfFile         = readFile("End of file")
  let  endOfFileJudge    = readFile("End of file judge")

  let challenge    = NSLocalizedString("challenge", tableName: "general", comment: "challenge")
  let awardOfMerit  = NSLocalizedString("Award of Merit", tableName: "general", comment: "award of merit")
    
  @IBOutlet var theShowController: NSArrayController!
  @IBOutlet var theEntriesController: NSArrayController!
    
  @IBOutlet weak var tableView: NSTableView!
  
  weak var appDelegate: AppDelegate!
  
  var managedObjectContext: NSManagedObjectContext!
  
  var addShowWindowController: AddShowWindowController? = nil
  var addEntryWindowController: EntrySheetController? = nil
    
  
  dynamic var sortByDate = [NSSortDescriptor(key: "date", ascending: false)]
  dynamic var sortByName = [NSSortDescriptor(key: "name", ascending: true)]
  
  override var windowNibName: String {
    return "MainWindowController"
  }
  
  // ================================
  // MARK: - Methods
  // ================================
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    let fetchRequest = NSFetchRequest(entityName: Show.entity)
    
    let results = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Show]
    for object in results {
      theShowController.addObject(object)
    }
    theShowController.rearrangeObjects()
    
    let centre = NSNotificationCenter.defaultCenter()
    centre.addObserver(self, selector: Selector("tableViewSelectionDidChange:"), name: NSTableViewSelectionDidChangeNotification, object: tableView)
  }
  
  func tableViewSelectionDidChange(aNotification: NSNotification) {
    if Globals.currentShowName.isEmpty {
      appDelegate.writeMenuTitle = "No show selected"
      appDelegate.writeMenuAvailable = false
    } else {
      appDelegate.writeMenuTitle = "Write \(Globals.currentShowName) ..."
    }
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
      speaker.startSpeakingString("adding an entry")
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
    let name = Globals.currentEntry!.cat.name
    if areYouSure("Do you really want to delete \(name)?") {
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
      sheetController.dateSet = true
      speaker.startSpeakingString("editing \(Globals.currentEntry!.cat.name)")
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
  
  // *****************************
  // MARK: - Write out catalogue
  // *****************************
  
  func displaySavePanel() {
    let savePanel = NSSavePanel()
    savePanel.allowedFileTypes = ["html"]
    savePanel.extensionHidden = false
    savePanel.canSelectHiddenExtension = false
    savePanel.nameFieldStringValue = "\(Globals.currentShowName).html"
    
    savePanel.beginSheetModalForWindow(window!, completionHandler: {
      [unowned savePanel] (result) in
      if result == NSModalResponseOK {
        self.printCatalog(savePanel.nameFieldStringValue, to: savePanel.URL!)
      }
    })
  }
  
}
