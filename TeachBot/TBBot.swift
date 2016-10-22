//
//  TBBot.swift
//  TrashBot
//
//  Created by Edward Guo on 2015-12-21.
//  Copyright © 2015 Peiliang Guo. All rights reserved.
//

import Foundation
import AudioKit

enum TBMotionDirection: Int, CustomStringConvertible {
    case stop
    case forward
    case backward
    case turnLeft
    case turnRight
    
    var description: String {
        switch self {
        case .stop: return "Stop";
        case .forward: return "Forward";
        case .backward: return "Backward";
        case .turnLeft: return "TurnLeft";
        case .turnRight: return "TurnRight";
        }
    }
}

protocol TBBotDelegate: class {
    func bot(print string: String)
    func bot(directionHasChanged direction: TBMotionDirection)
    func botFinishedCode()
}

class TBBot : NSObject, AVAudioPlayerDelegate {
    fileprivate var _direction = TBMotionDirection.stop
    
    weak var delegate: TBBotDelegate?
    
    var codeBlocks: [CodeBlock]
    var currentCodeBlock = CodeBlock.start
    
    let leftOscillator: AKPWMOscillator
    let rightOscillator: AKPWMOscillator
    
    let leftPanner: AKPanner
    let rightPanner: AKPanner
    
    let masterMixer: AKMixer
    
    var playingAudio = false
    
     init(codeBlcoks blocks: [CodeBlock]) {
        codeBlocks = blocks.reversed()
        
        leftOscillator  = AKPWMOscillator(frequency: 50.0)
        rightOscillator = AKPWMOscillator(frequency: 50.0)
        
        leftPanner  = AKPanner(leftOscillator,  pan: -1)
        rightPanner = AKPanner(rightOscillator, pan:  1)
        
        masterMixer = AKMixer(leftPanner, rightPanner)
        
        super.init()
        
        self.stopNodes()
    }
    
    func execute() {
        if let nextBlock = codeBlocks.popLast() {
            switch nextBlock {
            case .start:
                AudioKit.output = masterMixer
                AudioKit.start()
                
                execute()
                
            case .end:
                reset()
                delegate?.botFinishedCode()
                
            case .forward:
                update(.forward)
                execute()
                
            case .backward:
                update(.backward)
                execute()
                
            case .turnLeft:
                update(.turnLeft)
                execute()
                
            case .turnRight:
                update(.turnRight)
                execute()
                
            case .stop:
                update(.stop)
                execute()
                
            case .wait(let intereval):
                delegate?.bot(print: NSString(format: "Wait %.2f s", intereval) as String)
                Thread.sleep(forTimeInterval: intereval)
                execute()
            }
        } else {
            delegate?.botFinishedCode()
        }
    }
    
    fileprivate func update(_ direction: TBMotionDirection) {
        if direction != _direction {
            _direction = direction
        } else {
            return
        }
        delegate?.bot(directionHasChanged: _direction)
        
        
        switch direction {
        case .forward:
            startNodes()
            leftOscillator.pulseWidth = 0.3
            rightOscillator.pulseWidth = 0.7
        case .backward:
            startNodes()
            leftOscillator.pulseWidth = 0.7
            rightOscillator.pulseWidth = 0.3
        case .turnLeft:
            startNodes()
            leftOscillator.pulseWidth = 0.7
            rightOscillator.pulseWidth = 0.7
        case .turnRight:
            startNodes()
            leftOscillator.pulseWidth = 0.3
            rightOscillator.pulseWidth = 0.3
        case .stop:
            stopNodes()
        }
    }
    
    fileprivate func startNodes() {
        if !playingAudio {
            playingAudio = true
            
            leftOscillator.start()
            rightOscillator.start()
            
            leftPanner.start()
            rightPanner.start()
            
            masterMixer.start()
        }
    }
    
    fileprivate func stopNodes() {
        if playingAudio {
            playingAudio = false
            
            leftOscillator.stop()
            rightOscillator.stop()
            
            leftPanner.stop()
            rightPanner.stop()
            
            masterMixer.stop()
        }
    }
    
    fileprivate func reset() {
        _direction = .stop
        stopNodes()
    }
    
    deinit {
        AudioKit.engine.stop()
        AudioKit.engine.detach(masterMixer.avAudioNode)
    }
    
}
