//
//  MainWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  
  @objc let nbspace        = "&nbsp;".data
  
  @objc let  header1       = readFile("Header1")
  @objc let  header2       = readFile("Header2")
  @objc let  header2judge  = readFile("Header2judge")
  @objc let  tableStart    = readFile("Table start")
  @objc let  tableEnd      = readFile("Table end")
  @objc let  rowEnd        = "</tr>".data

  @objc let  head1         = readFile("head1")
  @objc let  head2         = readFile("head2")
  @objc let  head3         = readFile("head3")
  @objc let  head4         = readFile("head4")
  @objc let  head5         = readFile("head5")
  @objc let  head5_1       = readFile("head5_1")
  @objc let  head5_2       = readFile("head5_2")
  @objc let  head6         = readFile("head6")

  @objc let  section1      = readFile("Section1")
  @objc let  Section1_alt  = readFile("Section1 alt")
  @objc let  section2      = readFile("Section2")
  @objc let  section3      = readFile("Section3")
  @objc let  breed1        = readFile("Breed1")
  @objc let  breed2        = readFile("Breed2")
  @objc let  colour1       = readFile("Colour1")
  @objc let  colour2       = readFile("Colour2")
  @objc let  colour3       = readFile("Colour3")
  @objc let  name1         = readFile("Name1")
  @objc let  name1Litter   = readFile("Name1 litter")
  @objc let  name2         = readFile("Name2")
  @objc let  name2Litter   = readFile("Name2 litter")
  @objc let  name3         = readFile("Name3")
  @objc let  name4         = readFile("Name4")
  @objc let  details1      = readFile("Details1")
  @objc let  details1Litter = readFile("Details1 Litter")
  @objc let  details2      = readFile("Details2")
  @objc let  details3      = readFile("Details3")
  @objc let  details3Litter = readFile("Details3Litter")
  @objc let  details4      = readFile("Details4")
  @objc let  details5      = readFile("Details5")
  @objc let  challenge1    = readFile("Challenge1")
  @objc let  challenge2    = readFile("Challenge2")
  @objc let  challenge3    = readFile("Challenge3")
  @objc let  prestige1     = readFile("Prestige1")
  @objc let  bestAward1    = readFile("BestAward1")
  @objc let  bestAward2    = readFile("BestAward2")
  @objc let  bestAward3    = readFile("BestAward3")
  @objc let  bestAward4    = readFile("BestAward4")
  @objc let  entered       = readFile("Box entered")
  @objc let  notEntered    = readFile("Box not entered")
  @objc let  underlined    = readFile("Box underlined")
  @objc let  noRing        = readFile("Box no ring")
  
  @objc let  endOfEntries1     = readFile("EndOfEntries1")
  @objc let  endOfEntries2     = readFile("EndOfEntries2")
  @objc let  endOfEntriesJudge = readFile("EndOfEntriesJudge")
  
  @objc let  bestOfBreedStart  = readFile("BestOfBreedStart")
  @objc let  bestOfBreedEnd    = readFile("BestOfBreedEnd")
  @objc let  spacer            = readFile("Spacer")
  
  @objc let  ACFstartTable     = readFile("ACFAward start table")
  @objc let  ACFstartRow       = readFile("ACFAward start row")
  @objc let  ACFendRow         = readFile("ACFAward end row")
  
  let  ACFAoEstart       = readFile("ACFAoE start")
  let  ACFAoEstartRow    = readFile("ACFAoE start row")
  let  ACFAoEendRow      = readFile("ACFAoE end row")
  
  let  CCCAAwardsstart   = readFile("CCCAAwards1")

  let  topTenStartTable  = readFile("Top ten start table")
  let  topTenEndTable    = readFile("Top ten end table")
  
  let  endOfFile         = readFile("End of file")
  let  endOfFileJudge    = readFile("End of file judge")
  
  let challenge    = NSLocalizedString("Challenge", tableName: "general", comment: "Challenge")
  let awardOfMerit  = NSLocalizedString("Award of Merit", tableName: "general", comment: "Award of merit")
  
  @IBOutlet var theShowController: NSArrayController!
  @IBOutlet var theEntriesController: NSArrayController!
  
  @IBOutlet weak var tableView: NSTableView!
  
  @objc weak var appDelegate: AppDelegate!
  
  @objc var managedObjectContext: NSManagedObjectContext!
  
  @objc var addShowWindowController: AddShowWindowController? = nil
  @objc var addEntryWindowController: EntrySheetController? = nil
  
  @objc var mainWindow: NSWindow? {
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
    savePanel.allowedFileTypes = ["html"]
    savePanel.isExtensionHidden = false
    savePanel.canSelectHiddenExtension = false
    savePanel.nameFieldStringValue = "\(Globals.currentShowName).html"
    
    savePanel.beginSheetModal(for: window!, completionHandler: {
      [unowned savePanel] (result) in
      if result == NSApplication.ModalResponse.OK {
        self.printCatalog(savePanel.nameFieldStringValue, to: savePanel.url!)
      }
    })
  }
  
}
