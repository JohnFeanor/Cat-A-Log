//
//  RTF generator.swift
//  Cat-A-Log
//
//  Created by John Sandercock on 22/10/18.
//  Copyright © 2018 Feanor. All rights reserved.
//

import Foundation

enum RTF {
  
  enum FontType: Int, CustomStringConvertible {
    case timesNewRoman = 0
    case arial = 1
    case courierNew = 2
    case cambria = 42
    case times = 43
    case arialNarrow = 44
    case arialRoundedBold = 47
    
    var description: String {
      return "\\f\(self.rawValue)"
    }
  }

  enum FontStyle: Int, CustomStringConvertible {
    case none = 0
    case normal = 1
    case footer = 4
    case header = 20
    case breed = 29
    case colour = 30
    case number = 31
    case name = 32
    case catDetails = 33
    case bestOf = 35
    case box = 36
    case challengeHeader = 37
    case section = 39
    
    static let all: [FontStyle] = [.normal, .footer, .header, .breed, .colour, .number, .name, .catDetails, .bestOf, .box, .challengeHeader, .section]
    
    var description: String {
      return (self == .none ? "" : "\\s\(self.rawValue)")
    }
    
    var font: Font {
      switch self {
      case .footer:
        return Font(style: .footer, type: .cambria, size: 20, alignment: .right, spaceAbove: 80, spaceBelow: 80)
      case .header:
        return Font(style: .header, size: 20, alignment: .left, tabs: [Tab(6840), Tab(7420), Tab(8000), Tab(8580), Tab(9160), Tab(9740)])
      case .breed:
        return Font(style: .breed, size: 28, modifiers: [.bold, .keepWithNext], alignment: .centre, spaceAbove: 60, spaceBelow: 120)
      case .colour:
        return Font(style: .colour, modifiers: [.bold, .underline, .keepWithNext], spaceAbove: 80, spaceBelow: 120)
      case .number:
        return Font(style: .number, modifiers: [.bold, .keepWithNext], spaceAbove: 80, spaceBelow: 120)
      case .name:
        return Font(style: .name, type: .arialNarrow, modifiers: [.bold, .caps], spaceAbove: 80, spaceBelow: 120)
      case .catDetails:
        return Font(style: .catDetails, type: .arialNarrow, size: 22, modifiers: [.tight])
      case .bestOf:
        return Font(style: .bestOf, type: .arialRoundedBold, rightIndent: 20, spaceAbove: 120, spaceBelow: 120)
      case .box:
        return Font(style: .box, type: .arialRoundedBold, alignment: .centre)
      case .challengeHeader:
        return Font(style: .challengeHeader, type: .arialRoundedBold, size: 22, modifiers: [.keepWithNext], spaceBelow: 120)
      case .section:
        return Font(style: .section, size: 28, modifiers: [.bold, .keepWithNext, .noSpellingCheck, .pageBreakBefore], alignment: .centre, spaceAbove: 60, spaceBelow: 120)
      default:
        return Font()
      }
    }
    
    var basedOn: String {
      switch self {
      case .name:
        return "\\sbasedon31"
      case .section:
        return "\\sbasedon29"
      default:
        return "\\sbasedon0"
      }
    }
  }
  
  enum FontFace: String, CustomStringConvertible {
    case bold = "\\b"
    case italic = "\\i"
    case underline = "\\ul"
    case pageBreakBefore = "\\pagebb"
    case keepWithNext = "\\keepn"
    case noSpellingCheck = "\\noproof"
    case caps = "\\caps"
    case tight = "\\charscalex90"
    
    var description: String { return self.rawValue }
  }

  enum Language: Int, CustomStringConvertible {
    case Australia = 3081
    
    var description: String { return "\\langnp\(self.rawValue)" }
  }

  enum TextAlignment: String, CustomStringConvertible {
    case left = "\\ql"
    case right = "\\qr"
    case centre = "\\qc"
    case justified = "\\qj"
    
    var description: String { return self.rawValue }
  }
  
  enum CellAlignment: String, CustomStringConvertible {
    case top = "\\clvertalt"
    case centre = "\\clvertalc"
    case bottom = "\\clvertalb"
    
    var description: String { return self.rawValue }
  }

  enum BorderStyle: String, CustomStringConvertible {
    case single = "\\brdrs"
    case double = "\\brdrdb"
    case none = "a"
    
    var description: String { return self.rawValue }
  }
  
  struct Tab: CustomStringConvertible, Hashable {
    let alignment: TextAlignment
    let position: Int
    
    init(_ position: Int, alignment: TextAlignment = .left) {
      self.position = position
      self.alignment = alignment
    }
    
    var description: String {
      switch self.alignment {
      case .right:
        return "\\tqr\\tx\(position)"
      case .centre:
        return "\\tqc\\tx\(position)"
      case .justified:
        return "\\tqj\\tx\(position)"
      default:
        return "\\tql\\tx\(position)"
      }
    }
  }

  struct Paragraph: CustomStringConvertible {
    
    fileprivate var data: String
    fileprivate var font: Font
    
    init(text: String, font: Font = Font()) {
      self.data = text
      self.font = font
    }
    
    var description: String {
      return "{\\pard" + font.description + " " + data +  "\\par}\n"
    }
    
    var inCell: String {
      return "{\\pard\\intbl" + font.description + " " + data +  "\\cell}\n"
    }
  }
  
  struct Font: CustomStringConvertible {
    private let style: FontStyle
    private let type: FontType
    private let size: Int
    private let modifiers: Set<FontFace>
    private let alignment: TextAlignment
    private let rightIndent: Int
    private let leftIndent: Int
    private let spaceAbove: Int
    private let spaceBelow: Int
    private let tabs: Set<Tab>
    private let language: Language
    
    init(style: FontStyle = .normal, type: FontType = .arial, size: Int = 24, modifiers: Set<FontFace> = [], alignment: TextAlignment = .left, rightIndent: Int = 0, leftIndent: Int = 0, spaceAbove: Int = 0, spaceBelow: Int = 0, tabs: Set<Tab> = [], language: Language = .Australia) {
      self.style = style
      self.type = type
      self.modifiers = modifiers
      self.size = size
      self.alignment = alignment
      self.rightIndent = rightIndent
      self.leftIndent = leftIndent
      self.spaceAbove = spaceAbove
      self.spaceBelow = spaceBelow
      self.tabs = tabs
      self.language = language
    }
    
    var description: String {
      let mods = modifiers.reduce("", { $0 + $1.rawValue })
      let tbs = tabs.sorted(by: { $0.position < $1.position }).reduce(" ", { $0 + $1.description })
      let ans = "\(style) \(type)\\fs\(size)\\ri\(rightIndent)\\li\(leftIndent)\\sa\(spaceAbove)\\sb\(spaceBelow)\(alignment)" + mods + tbs + "\(language) "
      return ans
    }
  }

  struct Border: CustomStringConvertible {
    let style: BorderStyle
    let width: Int
    
    init(style: BorderStyle = .single, width: Int = 10) {
      self.style = style
      self.width = width
    }
    
    var description: String {
      return (self.style == .none ? "" : "\(style)\\brdrw\(width)")
    }
  }

  struct Cell: CustomStringConvertible {
    let topBorder: Border
    let leftBorder: Border
    let bottomBorder: Border
    let rightBorder: Border
    let alignment: CellAlignment
    let rightEdge: Int
    let paragraph: Paragraph
    let shaded: Bool
    
    init(rightEdge: Int, topBorder: Border = Border(), leftBorder: Border = Border(), bottomBorder: Border = Border(), rightBorder: Border = Border(), alignment: CellAlignment = .centre, shaded: Bool = false, paragraph: Paragraph) {
      self.topBorder = topBorder
      self.leftBorder = leftBorder
      self.bottomBorder = bottomBorder
      self.rightBorder = rightBorder
      self.alignment = alignment
      self.rightEdge = rightEdge
      self.shaded = shaded
      self.paragraph = paragraph
    }
    
    func clone(newText: String? = nil, topBorder newTop: Border? = nil, leftBorder newLeft: Border? = nil, bottomBorder newBottom: Border? = nil, rightBorder newRight: Border? = nil) -> Cell {
      let theText = newText ?? self.paragraph.data
      let theTop = newTop ?? self.topBorder
      let theLeft = newLeft ?? self.leftBorder
      let theBottom = newBottom ?? self.bottomBorder
      let theRight = newRight ?? self.rightBorder
      return Cell(rightEdge: self.rightEdge, topBorder: theTop, leftBorder: theLeft, bottomBorder: theBottom, rightBorder: theRight, alignment: self.alignment, shaded: self.shaded, paragraph: Paragraph(text: theText, font: self.paragraph.font))
    }
    
    var description: String {
      return "\\clbrdrt\(topBorder)\n\\clbrdrl\(leftBorder)\n\\clbrdrb\(bottomBorder)\n\\clbrdrr\(rightBorder)\n\(alignment)" + (shaded ? "\\clcbpat1" : "") + "\\cellx\(rightEdge)\n"
    }
  }
  
  struct Row {
    let cells: [Cell]
    let doNotBreak: Bool
    
    init(doNotBreak: Bool = true, cells: Cell...) {
      self.cells = cells
      self.doNotBreak = doNotBreak
    }
  }
  
  struct Table: CustomStringConvertible {
    let rows: [Row]
    
    init(rows: Row...) {
      self.rows = rows
    }
    
    var description: String {
      var ans = ""
      for (count, row) in rows.enumerated() {
        ans.append("{\\trowd \\irow\(count)\\irowband\(count)")
        if row.doNotBreak { ans.append("\\trkeep\n") }
        else { ans.append("\n")}
        for cell in row.cells {
          ans.append(cell.description)
        }
        for cell in row.cells {
          ans.append(cell.paragraph.inCell)
        }
        ans.append("\\row}\n")
      }
      return ans
    }
  }

}
