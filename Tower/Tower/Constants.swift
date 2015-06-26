//
//  Constants.swift
//  Tower
//
//  Created by Evil Cookie on 09/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//
// A file with all the constant values that are needed throughout the game.
// This file could also be seen as the settings, as changing things like the platform height will affect all the platforms in the game

import Foundation
import UIKit


// like borders of the screen
let kDefaultSpeed : CGFloat = 30.0
let kMinX: CGFloat = 27.0
let kMaxX: CGFloat = 348.0
let kPlatformHeight: CGFloat = 20.0
let kPlatformWidth : CGFloat = 120
let kPlayerHeight : CGFloat = 40.0
let kGapDistance : CGFloat = 40.0
let kSegmentNumber = 20
let kfloorDistance : CGFloat = 100

// colors
let kColorLightBlue : UIColor = UIColor(red: 204.0/255.0, green: 245.0/255.0, blue: 246.0/255.0, alpha: 1.0)
let kColorDarkBlue: UIColor = UIColor(red: 153.0/255, green: 245.0/255, blue: 246.0/255.0, alpha: 1.0)
let kColorDeepDarkBlue : UIColor = UIColor(red: 0/255, green: 51/255, blue: 102/255, alpha: 1.0)

// Z-Order: the order in which on sprite is drawn on top of the other (higher number is on top)
let backgroundZposition : CGFloat = 1
let platformZposition : CGFloat = 2
let playerZposition : CGFloat = 3
let menuZposition : CGFloat = 4
let buttonZposition : CGFloat = 5
let labelZpostion : CGFloat = 6

// categories for different sprite-physicsbodies
let playerCategory: UInt32 = 0x1 << 0
let platformCategory: UInt32 = 0x1 << 1
let upperTresholdCategory: UInt32 = 0x1 << 2
let lowerTresholdCategory: UInt32 = 0x1 << 3
let rockBottomCategory: UInt32 = 0x1 << 4
let finishLineCategory: UInt32 = 0x1 << 5
