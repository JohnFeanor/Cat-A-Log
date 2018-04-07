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
  
  let undo = UndoManager()
  
  override var undoManager: UndoManager  {
    return undo
  }
  
  func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager? {
    // The undo menu item is only enabled if we return a undoManager here
    return self.undoManager
  }

  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  
  @IBAction func titleUpdated(_ sender: NSTextField) {
    let rowIndex = titlesTableView.row(for: sender)
    let newTitle = sender.stringValue
    titles.setIndex(rowIndex, toTitle: newTitle)
  }
  
  func addNewTitle(_ newTitle: String, atIndex index: Int) {
    (undoManager.prepare(withInvocationTarget: self) as! TitleEditorController).removeTitleAtIndex(index)
    if !undoManager.isUndoing {
      undoManager.setActionName("add title")
    }
    titles.addNewTitle(newTitle, atIndex: index)
    titlesTableView.reloadData()
  }
  
  func removeTitleAtIndex(_ index: Int) {
    let oldTitle = titles.titleAtindex(index)
    (undoManager.prepare(withInvocationTarget: self) as! TitleEditorController).addNewTitle(oldTitle, atIndex: index)
    if !undoManager.isUndoing {
      undoManager.setActionName("remove title")
    }
    titles.removeTitleAtIndex(index)
    titlesTableView.reloadData()
  }
  
  @IBAction func addTitleButtonPushed(_ sender: NSButton) {
    let index = titlesTableView.selectedRow + 1
    self.addNewTitle("New Title", atIndex: index)
    titlesTableView.reloadData()
    titlesTableView.editColumn(0, row: index, with: nil, select: true)
  }
  
  @IBAction func removeTitleButtonPushed(_ sender: NSButton) {
    let index = titlesTableView.selectedRow
    self.removeTitleAtIndex(index)
    titlesTableView.reloadData()
  }

}
