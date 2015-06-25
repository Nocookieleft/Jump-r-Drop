//
//  Constants.swift
//  Tower
//
//  Created by Evil Cookie on 09/06/15.
//  Copyright (c) 2015 Evil Cookie. All rights reserved.
//

import Foundation
import UIKit


// constant values needed throughout the whole game
// like borders of the screen
let kDefaultSpeed : CGFloat = 30.0
let kMinX: CGFloat = 27.0
let kMaxX: CGFloat = 348.0
let kPlatformHeight: CGFloat = 20.0
let kPlayerHeight : CGFloat = 40.0
let kGapDistance : CGFloat = 40.0


// colors
let kColorLightBlue : UIColor = UIColor(red: 204.0/255.0, green: 245.0/255.0, blue: 246.0/255.0, alpha: 1.0)
let kColorDarkBlue: UIColor = UIColor(red: 153.0/255, green: 245.0/255, blue: 246.0/255.0, alpha: 1.0)
let kColorDeepDarkBlue : UIColor = UIColor(red: 0/255, green: 51/255, blue: 102/255, alpha: 1.0)



// categories for different sprite-physicsbodies
let playerCategory: UInt32 = 0x1 << 0
let platformCategory: UInt32 = 0x1 << 1
let upperTresholdCategory: UInt32 = 0x1 << 2
let lowerTresholdCategory: UInt32 = 0x1 << 3
let rockBottomCategory: UInt32 = 0x1 << 4
let finishLineCategory: UInt32 = 0x1 << 5
