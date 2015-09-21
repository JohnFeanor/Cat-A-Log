//
//  TitleEditorController.swift
//  CatBase
//
//  Created by John Sandercock on 21/09/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class TitleEditorController: NSWindowController {
  
  @IBOutlet weak var titlesTableView: NSTableView!
  
  override var windowNibName: String {
    return "TitleEditorController"
  }
  
  @IBOutlet var titles: Titles!
  
  let undo = NSUndoManager()
  
  override var undoManager: NSUndoManager  {
    return undo
  }
  
  func windowWillReturnUndoManager(window: NSWindow) -> NSUndoManager? {
    // The undo menu item is only enabled if we return a undoManager here
    return self.undoManager
  }

  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  
  @IBAction func titleUpdated(sender: NSTextField) {
    let rowIndex = titlesTableView.rowForView(sender)
    let newTitle = sender.stringValue
    titles.setIndex(rowIndex, toTitle: newTitle)
  }
  
  func addNewTitle(newTitle: String, atIndex index: Int) {
    undoManager.prepareWithInvocationTarget(self).removeTitleAtIndex(index)
    if !undoManager.undoing {
      undoManager.setActionName("add title")
    }
    titles.addNewTitle(newTitle, atIndex: index)
    titlesTableView.reloadData()
  }
  
  func removeTitleAtIndex(index: Int) {
    let oldTitle = titles.titleAtindex(index)
    undoManager.prepareWithInvocationTarget(self).addNewTitle(oldTitle, atIndex: index)
    if !undoManager.undoing {
      undoManager.setActionName("remove title")
    }
    titles.removeTitleAtIndex(index)
    titlesTableView.reloadData()
  }
  
  @IBAction func addTitleButtonPushed(sender: NSButton) {
    let index = titlesTableView.selectedRow + 1
    self.addNewTitle("New Title", atIndex: index)
    titlesTableView.reloadData()
    titlesTableView.editColumn(0, row: index, withEvent: nil, select: true)
  }
  
  @IBAction func removeTitleButtonPushed(sender: NSButton) {
    let index = titlesTableView.selectedRow
    self.removeTitleAtIndex(index)
    titlesTableView.reloadData()
  }

}
