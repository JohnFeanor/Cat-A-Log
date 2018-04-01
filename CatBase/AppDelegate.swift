//
//  AppDelegate.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

//typealias Dictionary = [String : AnyObject]

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var timesleftToRunString: NSTextField!
  
  @IBOutlet weak var progressWheel: NSProgressIndicator!
  
  var mainWindowController: MainWindowController?
  var coloursEditorController: ColoursWindowController? = nil
  var criticalAgesWindowController: CriticalAgesWindowController? = nil
  var titleEditorController: TitleEditorController? = nil
  
  var openPanel: NSOpenPanel? = nil
  var savePanel: NSSavePanel? = nil
  
  var progressPanel: ProgressWindowController? = nil
  
  var myProgress = 0.0
  
  dynamic var writeMenuTitle = "Write catalogue ..."
  dynamic var writeMenuAvailable = true
  
  dynamic var iconImage = NSImage(named: "icon.jpg")
  
  var willIexit = false
  
  @IBAction func splashWindowClosed(_ sender: AnyObject) {
    window.close()
    if willIexit {
      exit(EXIT_SUCCESS)
    }
    
    // Create a window controller
    let mainWindowController = MainWindowController()
    mainWindowController.managedObjectContext = self.managedObjectContext
    //Put the window of the window controller on screen
    mainWindowController.showWindow(self)
    mainWindowController.appDelegate = self
    
    //Set the property to point to the window controller
    self.mainWindowController = mainWindowController
 
  }
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    var authenticate = arrayFromPList("Authentication") as! [String]
    if let triesLeft = Int(authenticate[0]) {
      if triesLeft > 0 {
        if triesLeft > 1 {
          timesleftToRunString.stringValue = "\(triesLeft) trials left"
        } else {
          timesleftToRunString.stringValue = "\(triesLeft) trial left"
        }
        authenticate[0] = String(triesLeft - 1)
        if !array(authenticate as [AnyObject], ToPlist: "Authentication") {
          print("Could not save authentication number")
        }
      } else {
        timesleftToRunString.stringValue = "You have no more free trials left"
        willIexit = true
      }
    } else {
      timesleftToRunString.stringValue = authenticate[0]
    }
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
    Colours.saveColours()
    Globals.saveCriticalAges()
    Titles.saveTitles()
  }
  
  // MARK: - Core Data stack
  
  lazy var applicationDocumentsDirectory: URL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Feanor.CatBase" in the user's Application Support directory.
    let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    let appSupportURL = urls[urls.count - 1] 
    return appSupportURL.appendingPathComponent("com.Feanor.CatBase")
    }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = Bundle.main.url(forResource: "CatBase", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
    }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.) This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    let fileManager = FileManager.default
    var shouldFail = false
    var error: NSError? = nil
    var failureReason = "There was an error creating or loading the application's saved data."
    
    // Make sure the application files directory is there
    let propertiesOpt: [AnyHashable: Any]?
    do {
      propertiesOpt = try (self.applicationDocumentsDirectory as NSURL).resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
    } catch var error1 as NSError {
      error = error1
      propertiesOpt = nil
    } catch {
      fatalError()
    }
    if let properties = propertiesOpt {
      if !(properties[URLResourceKey.isDirectoryKey]! as AnyObject).boolValue {
        failureReason = "Expected a folder to store application data, found a file \(self.applicationDocumentsDirectory.path)."
        shouldFail = true
      }
    } else if error!.code == NSFileReadNoSuchFileError {
      error = nil
      do {
        try fileManager.createDirectory(atPath: self.applicationDocumentsDirectory.path, withIntermediateDirectories: true, attributes: nil)
      } catch var error1 as NSError {
        error = error1
      } catch {
        fatalError()
      }
    }
    
    // Create the coordinator and store
    var coordinator: NSPersistentStoreCoordinator?
    let options = [NSMigratePersistentStoresAutomaticallyOption : true,
      NSInferMappingModelAutomaticallyOption : true]
    if !shouldFail && (error == nil) {
      coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
      let url = self.applicationDocumentsDirectory.appendingPathComponent("CatBase.storedata")
      do {
        try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
      } catch var error1 as NSError {
        error = error1
        coordinator = nil
        print("Could not create managed object coordinator \(error), \(error!.userInfo)")
      } catch {
        fatalError()
      }
    }
    
    if shouldFail || (error != nil) {
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
      dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
      if error != nil {
        dict[NSUnderlyingErrorKey] = error
      }
      error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      NSApplication.shared().presentError(error!)
      return nil
    } else {
      return coordinator
    }
    }()
  
  lazy var managedObjectContext: NSManagedObjectContext? = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
    }()
  
  // MARK: - Core Data Saving and Undo support
  
  @IBAction func saveAction(_ sender: AnyObject!) {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    if let moc = self.managedObjectContext {
      if !moc.commitEditing() {
        NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
      }
      var error: NSError? = nil
      if moc.hasChanges {
        do {
          try moc.save()
        } catch let error1 as NSError {
          error = error1
          NSApplication.shared().presentError(error!)
        }
      }
    }
  }
  
  func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager? {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    if let moc = self.managedObjectContext {
      return moc.undoManager
    } else {
      return nil
    }
  }
  
  func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
    // Save changes in the application's managed object context before the application terminates.
    
    if let moc = managedObjectContext {
      if !moc.commitEditing() {
        print("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
        return .terminateCancel
      }
      
      if !moc.hasChanges {
        return .terminateNow
      }
      
      var error: NSError? = nil
      print("Saving managed object context")
      do {
        try moc.save()
      } catch let error1 as NSError {
        error = error1
        // Customize this code block to include application-specific recovery steps.
        let result = sender.presentError(error!)
        if (result) {
          return .terminateCancel
        }
        
        let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
        let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
        let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
        let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = info
        alert.addButton(withTitle: cancelButton)
        alert.addButton(withTitle: quitButton)
        
        let answer = alert.runModal()
        if answer == NSAlertFirstButtonReturn {
          return .terminateCancel
        }
      }
    }
    // If we got here, it is time to quit.
    return .terminateNow
  }
  
  
  // ========================
  // MARK: - Menu actions
  // ========================
  
  @IBAction func writeFiles(_ sender: NSMenuItem) {
    if let mainWindowController = self.mainWindowController {
      mainWindowController.displaySavePanel()
    }
  }
  
  fileprivate func openEditor(_ editor: NSWindowController) {
    if let theWindow = editor.window {
      if !theWindow.isVisible {
        editor.showWindow(self)
      } else {
        editor.close()
      }
    } else {
      editor.showWindow(self)
    }
  }
  
  @IBAction func openColoursEditor(_ sender: NSMenuItem) {
    if coloursEditorController == nil {
      coloursEditorController = ColoursWindowController()
    }
    openEditor(coloursEditorController!)
  }
  
  @IBAction func displayCriticalAges(_ sender: NSMenuItem) {
    if criticalAgesWindowController == nil {
      criticalAgesWindowController = CriticalAgesWindowController()
    }
    openEditor(criticalAgesWindowController!)
  }
  
  @IBAction func openTitlesEditor(_ sender: NSMenuItem) {
    if titleEditorController == nil {
      titleEditorController = TitleEditorController()
    }
    openEditor(titleEditorController!)
  }
  
  @IBAction func importACatFile(_ sender: NSObject) {
    let panel = NSOpenPanel()
    panel.canChooseDirectories = false
    panel.allowsMultipleSelection = false
    panel.message = "Name of file to import"
    panel.allowedFileTypes = ["cats"]
    guard let mainWindow = mainWindowController?.mainWindow
      else { fatalError("Main window is nil") }
    
    panel.beginSheetModal(for: mainWindow) { response in
      // The sheet has finished. Did the user click 'OK'?
      if response == NSModalResponseOK {
        // import the cats
        if let url = self.openPanel?.url {
          self.progressPanel = ProgressWindowController()
          // delay so that the open panel can close
          self.perform(#selector(AppDelegate.importCatsAtURL(_:)), with: url, afterDelay: 0.1)
        } else {
          errorAlert(message: "Cannot open the cat file")
        }
        self.openPanel = nil
      }
    }
    openPanel = panel
  }
  
  func importCatsAtURL(_ url: URL) {
    let buffer: NSString
    do { buffer = try NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) }
    catch {
      errorAlert(message: "Error trying to read Cats file")
      return
    }
    guard let progressPanel = self.progressPanel
      else { errorAlert(message: "Cannot open progress panel"); return }
    
    let strings = buffer.components(separatedBy: "\t")
    
    let numberOfCatProperties = Cat.positions.count
    let numberOfCats = strings.count / numberOfCatProperties
    print("Preparing to import \(numberOfCats) cats")
    speaker.startSpeaking("This may take a while")
    if let mainWindow = mainWindowController?.window {
      progressPanel.beginCountDown(onWindow: mainWindow, withLabel: "Preparing to import \(numberOfCats) cats")
    }

    var start = 0
    var duplicates = 0
    var count = 0
    
    for _ in 0 ..< numberOfCats {
      let end = start + numberOfCatProperties
      let thisCat = Array(strings[start ..< end])
      let registration = thisCat[Cat.positions[Cat.registration]!]
      let name = thisCat[Cat.positions[Cat.name]!]
      
      if existingCatsWithRegistration(registration, orName: name, inContext: self.managedObjectContext!) == nil {
        let _ = Cat(array:thisCat, insertIntoManagedObjectContext: self.managedObjectContext)
        count += 1
      } else {
        duplicates += 1
      }
      start = end
    }
    _ = runAlertWithMessage("Imported \(count) cats.\nFound \(duplicates) cats already in the database.\nDuplicates were not imported.", buttons: "OK")
    progressPanel.endCountDown()

    do { try self.managedObjectContext!.save() }
    catch{
      errorAlert(message: "Warning: the imported cats could not be saved into the database")
    }
    self.progressPanel = nil
  }
  
  @IBAction func exportACatFile(_ sender: AnyObject) {
    let panel = NSSavePanel()
    panel.allowedFileTypes = ["cats"]
    guard let mainWindow = mainWindowController?.window
      else { fatalError("Main window is nil") }
    
    panel.beginSheetModal(for: mainWindow) {
      (result) in
      if result == NSModalResponseOK {
        let url = self.savePanel?.url
        self.exportCatsToURL(url)
        self.savePanel = nil
      }
    }
    savePanel = panel
  }
  
  fileprivate func exportCatsToURL(_ url: URL?) {
    guard let context = self.managedObjectContext
      else { return }
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Cat.nomen)
    let fetchResult: [Cat]?
    do {
      fetchResult = try context.fetch(fetchRequest) as? [Cat]
    } catch {
      print("\n** Error in fetch request **\n")
      return
    }
    if let fetchResult = fetchResult {
      print("Exporting \(fetchResult.count) cats")
      let printData = NSMutableData()
      for cat in fetchResult {
        printData.append(cat.catString.data as Data)
      }
      let ok = printData.write(to: url!, atomically: true)
      if !ok {
        errorAlert(message: "Could not write cats to file")
      } else {
        print("Exported \(fetchResult.count) cats")
      }
    } else {
      print("Did not fetch or export any cats")
    }
  }
  

  
}


