//
//  RuntimeViewController.swift
//  TrashBot
//
//  Created by Edward Guo on 2015-12-21.
//  Copyright © 2015 Peiliang Guo. All rights reserved.
//

import UIKit

class RuntimeViewController: UIViewController, TBBotDelegate {
    
    @IBOutlet weak var displayTextView: UITextView!
    @IBOutlet weak var stopButton: UIButton!
    
    var codeBlocks: CodeBlock?
    var bot: TBBot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bot = TBBot()
        bot!.delegate = self
        
        self.stopButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bot(bot: TBBot, directionHasChanged direction: TBMotionDirection) {
        appendTextToDisplay(direction.description, tag: "Motion")
    }
    
    func bot(bot: TBBot, print string: String) {
        appendTextToDisplay(string, tag: "Print")
    }
    
    func appendTextToDisplay(string: String, tag: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.displayTextView.text = "[\(tag)]\(string)\n" + self.displayTextView.text
        }
    }
}
