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
    case Stop
    case Forward
    case Backward
    case TurnLeft
    case TurnRight
    
    var description: String {
        switch self {
        case .Stop: return "Stop";
        case .Forward: return "Forward";
        case .Backward: return "Backward";
        case .TurnLeft: return "TurnLeft";
        case .TurnRight: return "TurnRight";
        }
    }
}

protocol TBBotDelegate: class {
    func bot(print string: String)
    func bot(directionHasChanged direction: TBMotionDirection)
    func botFinishedCode()
}

class TBBot : NSObject, AVAudioPlayerDelegate {
    private var _direction = TBMotionDirection.Stop
    
    weak var delegate: TBBotDelegate?
    
    var codeBlocks: [CodeBlock]
    var currentCodeBlock = CodeBlock.Start
    
    let leftOscillator: AKPWMOscillator
    let rightOscillator: AKPWMOscillator
    
    let leftPanner: AKPanner
    let rightPanner: AKPanner
    
    let masterMixer: AKMixer
    
    var playingAudio = false
    
     init(codeBlcoks blocks: [CodeBlock]) {
        codeBlocks = blocks.reverse()
        
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
            case .Start:
                AudioKit.output = masterMixer
                AudioKit.start()
                
                execute()
                
            case .End:
                reset()
                delegate?.botFinishedCode()
                
            case .Forward:
                update(direction: .Forward)
                execute()
                
            case .Backward:
                update(direction: .Backward)
                execute()
                
            case .TurnLeft:
                update(direction: .TurnLeft)
                execute()
                
            case .TurnRight:
                update(direction: .TurnRight)
                execute()
                
            case .Stop:
                update(direction: .Stop)
                execute()
                
            case .Wait(let intereval):
                delegate?.bot(print: NSString(format: "Wait %.2f s", intereval) as String)
                NSThread.sleepForTimeInterval(intereval)
                execute()
            }
        } else {
            delegate?.botFinishedCode()
        }
    }
    
    private func update(direction direction: TBMotionDirection) {
        if direction != _direction {
            _direction = direction
        } else {
            return
        }
        delegate?.bot(directionHasChanged: _direction)
        
        
        switch direction {
        case .Forward:
            startNodes()
            leftOscillator.pulseWidth = 0.3
            rightOscillator.pulseWidth = 0.7
        case .Backward:
            startNodes()
            leftOscillator.pulseWidth = 0.7
            rightOscillator.pulseWidth = 0.3
        case .TurnLeft:
            startNodes()
            leftOscillator.pulseWidth = 0.7
            rightOscillator.pulseWidth = 0.7
        case .TurnRight:
            startNodes()
            leftOscillator.pulseWidth = 0.3
            rightOscillator.pulseWidth = 0.3
        case .Stop:
            stopNodes()
        }
    }
    
    private func startNodes() {
        if !playingAudio {
            playingAudio = true
            
            leftOscillator.start()
            rightOscillator.start()
            
            leftPanner.start()
            rightPanner.start()
            
            masterMixer.start()
        }
    }
    
    private func stopNodes() {
        if playingAudio {
            playingAudio = false
            
            leftOscillator.stop()
            rightOscillator.stop()
            
            leftPanner.stop()
            rightPanner.stop()
            
            masterMixer.stop()
        }
    }
    
    private func reset() {
        _direction = .Stop
        stopNodes()
    }
    
    deinit {
        AudioKit.engine.stop()
        AudioKit.engine.detachNode(masterMixer.avAudioNode)
    }
    
}
