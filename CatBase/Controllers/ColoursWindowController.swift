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
  
  @IBAction func newBreedselected(sender: NSTableView) {
    print("asking colours to reload")
    coloursTableView.reloadData()
  }

  
  @IBAction func colourUpdated(sender: NSTextField) {
    let rowIndex = coloursTableView.rowForView(sender)
    let newColour = sender.stringValue
    colours.setIndex(rowIndex, toColour: newColour)
  }
  
  func addNewColour(newColour: String, atIndex index: Int) {
    undoManager.prepareWithInvocationTarget(self).removeColourAtIndex(index)
    if !undoManager.undoing {
      undoManager.setActionName("add colour")
    }
    colours.addNewColour(newColour, atIndex: index)
    coloursTableView.reloadData()
  }
  
  func removeColourAtIndex(index: Int) {
    let oldColour = colours.colourAtIndex(index)
    undoManager.prepareWithInvocationTarget(self).addNewColour(oldColour, atIndex: index)
    if !undoManager.undoing {
      undoManager.setActionName("remove colour")
    }
    colours.removeColourAtIndex(index)
    coloursTableView.reloadData()
  }
  
  @IBAction func addColourButtonPushed(sender: NSButton) {
    let index = coloursTableView.selectedRow + 1
    self.addNewColour("New Colour", atIndex: index)
    coloursTableView.reloadData()
    coloursTableView.editColumn(0, row: index, withEvent: nil, select: true)
  }
  
  @IBAction func removeColourButtonPushed(sender: NSButton) {
    let index = coloursTableView.selectedRow
    self.removeColourAtIndex(index)
    coloursTableView.reloadData()
  }
}
