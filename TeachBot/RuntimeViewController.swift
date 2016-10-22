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
    
    var codeBlocks: [CodeBlock]?
    var bot: TBBot?
    
    let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bot = TBBot(codeBlcoks: codeBlocks!)
        bot!.delegate = self
        
        queue.qualityOfService = .userInitiated
        queue.name = "TBBot-Queue"
        queue.maxConcurrentOperationCount = 1
        
        self.stopButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let operation = TBBotExecutionOperation()
        operation.bot = bot
        
        queue.addOperation(operation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bot(directionHasChanged direction: TBMotionDirection) {
        appendTextToDisplay(direction.description, tag: "Motion")
    }
    
    func bot(print string: String) {
        appendTextToDisplay(string, tag: "Print")
    }
    
    func botFinishedCode() {
        appendTextToDisplay("Finished code", tag: "Exit")
        
        DispatchQueue.main.async {
            self.stopButton.setTitle("Done", for: UIControlState())
            self.stopButton.isEnabled = true
        }
    }
    
    func appendTextToDisplay(_ string: String, tag: String) {
        DispatchQueue.main.async { () -> Void in
            self.displayTextView.text = "[\(tag)]\(string)\n" + self.displayTextView.text
        }
    }
    
    @IBAction func stop(_ sender: UIButton) {
        performSegue(withIdentifier: "finishCode", sender: self)
    }
}

class TBBotExecutionOperation: Operation {
    var bot: TBBot?
    
    override func main () {
        bot!.execute()
    }
}
