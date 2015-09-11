//
//  Printing.swift
//  CatBase
//
//  Created by John Sandercock on 6/09/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

struct Litter {
  var name: String
  var birthDate: NSDate
  var breed: String
  var sire: String
  var dam: String
  var breeder: String
  var exhibitor: String
  var females: Int = 0
  var males: Int = 0
  var neuters: Int = 0
  var spays: Int = 0

  init(entry: Entry) {
    let cat = entry.cat
    name = cat.name
    birthDate = cat.birthDate
    breed = cat.breed
    sire = cat.sire
    dam = cat.dam
    breeder = cat.breeder
    exhibitor = cat.exhibitor
  }
  
  func contains(cat: Cat) -> Bool {
    if !self.birthDate.isEqualToDate(cat.birthDate) { return false }
    if self.sire != cat.sire { return false }
    if self.dam != cat.dam { return false }
    return true
  }
  
  mutating func addKittenOfSex(sex: String) {
    switch sex {
    case Sex.sexes[0]:
      self.males++
    case Sex.sexes[1]:
      self.females++
    case Sex.sexes[2]:
      self.neuters++
    case Sex.sexes[3]:
      self.spays++
    default:
      break
    }
  }
}

func readFile(fileName: String) -> NSData? {
  let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
  if let path = path {
    let data = NSFileManager.defaultManager().contentsAtPath(path)
    return data
  }
  return nil
}

//- (void)doChallengeFor:(Entry *)thisEntry with:(id)theChallenges
//{
//  if ([thisEntry isKitten]) {
//  return; }
//  if ([theChallenges isKindOfClass:[NSMutableArray class]])
//{
//  if ([theChallenges count] > 0) {
//  [allData appendData:spacer];
//  if ([thisEntry isCompanion]) {
//  [self writeChallenge:theChallenges for:awardOfMerit];
//  }
//  else
//  [self writeChallenge:theChallenges for:challenge];
//  }
//  if ([entry sameColourAndBreedTo:lastEntry])
//  [allData appendData:spacer];
//  [theChallenges removeAllObjects];
//}
//  else if ([theChallenges isKindOfClass:[NSDictionary class]])
//{
//  NSArray *males    = [theChallenges objectForKey:MALE];
//  NSArray *females  = [theChallenges objectForKey:FEMALE];
//  NSInteger m = [males count];
//  NSInteger f = [females count];
//  NSString *male;
//  NSString *female;
//  if ((f+m) > 0)
//  [allData appendData:prestige1];
//  NSString *awardType = nil;
//  if ([thisEntry isEntire]) {
//  male = [Sexes sexForNumber:0];
//  female = [Sexes sexForNumber:1];
//} else {
//  male = [Sexes sexForNumber:2];
//  female = [Sexes sexForNumber:3];
//  }
//  if ([thisEntry isCompanion]) {
//  awardType = awardOfMerit;
//} else {
//  awardType = challenge;
//  }
//  if (m)
//  [self writeChallenge:males for:[NSString stringWithFormat:@"%@ %@ %@", male,
//  [theChallenges objectForKey:TITLE], awardType]];
//  if (f)
//  [self writeChallenge:females for:[NSString stringWithFormat:@"%@ %@ %@", female,
//  [theChallenges objectForKey:TITLE], awardType]];
//  clean(theChallenges);
//  if ((f+m) > 0)
//  [allData appendData:bestAward1];    // end table and put in crlf
//  }
//  else
//  NSLog(@"Unknown class given to doChallengeFor: %@", theChallenges);
//}

extension MainWindowController {
  func printCatalog(name: String, to url: NSURL) {
    
    var openChallenges: [NSNumber] = []
    
    func doOpenChallengeFor(thisEntry: Entry, changingColour changeColour: Bool ) {
      // ** Kittens do not have challenges
      if thisEntry.cat.isKitten { return }
      
      if openChallenges.isEmpty {
        //  [allData appendData:spacer];
        if thisEntry.cat.isCompanion {
          //  [self writeChallenge:theChallenges for:awardOfMerit];
        } else {
          //  [self writeChallenge:theChallenges for:challenge];
        }
        if !changeColour {
          //  [allData appendData:spacer];
        }
        
        openChallenges = []
      }
      
      
      
      let sortedEntrys = theEntriesController.arrangedObjects.sortedArrayUsingSelector(Selector("compareWith:")) as! [Entry]
      
      // ***************************************
      // MARK: - sort through and find litters
      // ***************************************
      var litters: [Litter] = []
      for entry in sortedEntrys {
        if entry.isInLitter {
          var newLitter = true
          for litter in litters {
            if entry.isInLitter(litter) {
              newLitter = false
              break
            }
          }
          if newLitter {
            litters += [Litter(entry: entry)]
          }
        }
      }
      
      // *****************************************
      // MARK: - Find all kittens in the litters
      //         Update them to show they are in litters
      // *****************************************
      
      for entry in sortedEntrys {
        for var litter in litters {
          guard entry.isInLitter(litter)
            else { continue }
          entry.litter = true
          litter.addKittenOfSex(entry.cat.sex)
          
          break
        }
      }
      
      // ****************************************************
      // MARK: - loop through the entries to print them out
      // ****************************************************
      
      var lastEntry: Entry? = nil
      for entry in sortedEntrys {
        if let lastEntry = lastEntry {
          let lastAgouti = lastEntry.cat.agoutiRank
          
          // MARK: - write out open challenges
          // ---------------------------------
          if !entry.sameColourAs(lastEntry) {
            doOpenChallengeFor(lastEntry, changingColour: lastEntry.cat.colour == entry.cat.colour)
          }
        }
      }
      
    }
  }
  
}