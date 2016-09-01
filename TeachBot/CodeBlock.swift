//
//  CodeBlock.swift
//  TeachBot
//
//  Created by Edward Guo on 2016-08-31.
//  Copyright © 2016 Pei Liang Guo. All rights reserved.
//

import Foundation

enum CodeBlock: CustomStringConvertible {
    case Start
    case End
    
    case Stop
    
    case Forward
    case Backward
    
    case TurnLeft
    case TurnRight
    
    case Wait(Double)
    
    var description: String {
        switch self {
        case .Forward:
            return "Forward"
        case .Backward:
            return "Backward"
        case .TurnLeft:
            return "Turn Left"
        case .TurnRight:
            return "Turn Right"
        case .Stop:
            return "Stop"
        case .Start:
            return "Start"
        case .End:
            return "End"
        case .Wait(let interval):
            if interval == 0.0 {
                return "Wait"
            } else {
                return NSString(format: "Wait %.1f s", interval) as String
            }
        }
    }
    
    static var allEditableCodeBlocks: [CodeBlock] {
        return [.Forward, .Backward, .TurnLeft, .TurnRight, Wait(0.0), .Stop]
    }
}
