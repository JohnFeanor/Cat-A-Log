//
//  ColoursWindowController.swift
//  CatBase
//
//  Created by John Sandercock on 18/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class ColoursWindowController: NSWindowController {
  
  @IBOutlet weak var coloursTableView: NSTableView!
  @IBOutlet var colours: Colours!
  
  override var windowNibName: String {
    return "ColoursWindowController"
  }
  
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
  
  @IBAction func newBreedselected(_ sender: NSTableView) {
    coloursTableView.reloadData()
  }

  
  @IBAction func colourUpdated(_ sender: NSTextField) {
    let rowIndex = coloursTableView.row(for: sender)
    let newColour = sender.stringValue
    colours.setIndex(rowIndex, toColour: newColour)
  }
  
  func addNewColour(_ newColour: String, atIndex index: Int) {
    (undoManager.prepare(withInvocationTarget: self) as AnyObject).removeColourAtIndex(index)
    if !undoManager.isUndoing {
      undoManager.setActionName("add colour")
    }
    colours.addNewColour(newColour, atIndex: index)
    coloursTableView.reloadData()
  }
  
  func removeColourAtIndex(_ index: Int) {
    let oldColour = colours.colourAtIndex(index)
    (undoManager.prepare(withInvocationTarget: self) as AnyObject).addNewColour(oldColour, atIndex: index)
    if !undoManager.isUndoing {
      undoManager.setActionName("remove colour")
    }
    colours.removeColourAtIndex(index)
    coloursTableView.reloadData()
  }
  
  @IBAction func addColourButtonPushed(_ sender: NSButton) {
    let index = coloursTableView.selectedRow + 1
    self.addNewColour("New Colour", atIndex: index)
    coloursTableView.reloadData()
    coloursTableView.editColumn(0, row: index, with: nil, select: true)
  }
  
  @IBAction func removeColourButtonPushed(_ sender: NSButton) {
    let index = coloursTableView.selectedRow
    self.removeColourAtIndex(index)
    coloursTableView.reloadData()
  }
}
