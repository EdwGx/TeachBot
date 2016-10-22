//
//  CodeBlock.swift
//  TeachBot
//
//  Created by Edward Guo on 2016-08-31.
//  Copyright © 2016 Pei Liang Guo. All rights reserved.
//

import Foundation

enum CodeBlock: CustomStringConvertible {
    case start
    case end
    
    case stop
    
    case forward
    case backward
    
    case turnLeft
    case turnRight
    
    case wait(Double)
    
    var description: String {
        switch self {
        case .forward:
            return "Forward"
        case .backward:
            return "Backward"
        case .turnLeft:
            return "Turn Left"
        case .turnRight:
            return "Turn Right"
        case .stop:
            return "Stop"
        case .start:
            return "Start"
        case .end:
            return "End"
        case .wait(let interval):
            if interval == 0.0 {
                return "Wait"
            } else {
                return NSString(format: "Wait %.2f s", interval) as String
            }
        }
    }
    
    func isWait() -> Bool {
        switch self {
        case .wait(_): return true
        default: return false
        }
    }
    
    func isMotion() -> Bool {
        switch self {
        case .forward, .backward, .turnLeft, .turnRight, .stop: return true
        default: return false
        }
    }
    
    static var allEditableCodeBlocks: [CodeBlock] {
        return [.forward, .backward, .turnLeft, .turnRight, wait(0.0), .stop]
    }
}
