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
  
  let  header1       = readFile("Header1")
  let  header2       = readFile("Header2")
  let  header2judge  = readFile("Header2judge")
  let  tableStart    = readFile("Table start")
  let  tableEnd      = readFile("Table end")
  let  rowEnd        = "</tr>".data

  let  head1         = readFile("head1")
  let  head2         = readFile("head2")
  let  head3         = readFile("head3")
  let  head4         = readFile("head4")
  let  head5         = readFile("head5")
  let  head5_1       = readFile("head5_1")
  let  head5_2       = readFile("head5_2")
  let  head6         = readFile("head6")

  let  section1      = readFile("Section1")
  let  Section1_alt  = readFile("Section1 alt")
  let  section2      = readFile("Section2")
  let  section3      = readFile("Section3")
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
  
  let  endOfEntries1     = readFile("EndOfEntries1")
  let  endOfEntries2     = readFile("EndOfEntries2")
  let  endOfEntriesJudge = readFile("EndOfEntriesJudge")
  
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

  let challenge    = NSLocalizedString("Challenge", tableName: "general", comment: "Challenge")
  let awardOfMerit  = NSLocalizedString("Award of Merit", tableName: "general", comment: "Award of merit")
    
  @IBOutlet var theShowController: NSArrayController!
  @IBOutlet var theEntriesController: NSArrayController!
    
  @IBOutlet weak var tableView: NSTableView!
  
  weak var appDelegate: AppDelegate!
  
  var managedObjectContext: NSManagedObjectContext!
  
  var addShowWindowController: AddShowWindowController? = nil
  var addEntryWindowController: EntrySheetController? = nil
  
  var mainWindow: NSWindow? {
    return window
  }
    
  
  dynamic var sortByDate = [NSSortDescriptor(key: "date", ascending: false)]
  dynamic var sortByName = [NSSortDescriptor(key: "name", ascending: true)]
  dynamic var sortByNameAndBreed  = [NSSortDescriptor(key: "breed", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
  
  override var windowNibName: String {
    return "MainWindowController"
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
    centre.addObserver(self, selector: #selector(NSTableViewDelegate.tableViewSelectionDidChange(_:)), name: NSNotification.Name.NSTableViewSelectionDidChange, object: tableView)
  }
  
  func tableViewSelectionDidChange(_ aNotification: Notification) {
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
  
  var myUndoManager: UndoManager {
    get {
      if let mum = self.managedObjectContext.undoManager {
        return mum
      } else {
        self.managedObjectContext.undoManager = UndoManager()
        print("created an undoManager")
        return self.managedObjectContext.undoManager!
      }
    }
  }

  func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager {
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
        if response == NSModalResponseOK {
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
          if response == NSModalResponseOK {
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
        if response == NSModalResponseOK {
          
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
        if response == NSModalResponseOK {
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
  
  func displaySavePanel() {
    let savePanel = NSSavePanel()
    savePanel.allowedFileTypes = ["html"]
    savePanel.isExtensionHidden = false
    savePanel.canSelectHiddenExtension = false
    savePanel.nameFieldStringValue = "\(Globals.currentShowName).html"
    
    savePanel.beginSheetModal(for: window!, completionHandler: {
      [unowned savePanel] (result) in
      if result == NSModalResponseOK {
        self.printCatalog(savePanel.nameFieldStringValue, to: savePanel.url!)
      }
    })
  }
  
}
