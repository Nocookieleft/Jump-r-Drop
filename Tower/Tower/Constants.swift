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
let kDefaultXtoMovePerSecond : CGFloat = 30.0
let kMinX: CGFloat = 27.0
let kMaxX: CGFloat = 348.0
let kPlatformHeight: CGFloat = 20.0


// categories
let playerCategory: UInt32 = 0x1 << 0
let platformCategory: UInt32 = 0x1 << 1
