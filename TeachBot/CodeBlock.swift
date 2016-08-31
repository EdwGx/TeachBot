//
//  CodeBlock.swift
//  TeachBot
//
//  Created by Edward Guo on 2016-08-31.
//  Copyright © 2016 Pei Liang Guo. All rights reserved.
//

import Foundation

enum CodeBlock {
    case Stop
    
    case Forward
    case Backward
    
    case TurnLeft
    case TurnRight
    
    case Wait(Double)
}
