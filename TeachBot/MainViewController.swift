//
//  ViewController.swift
//  TeachBot
//
//  Created by Edward Guo on 2016-08-30.
//  Copyright © 2016 Pei Liang Guo. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    var codeBlocks: [CodeBlock] = [CodeBlock]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeBlocks = [CodeBlock.Start,
                      CodeBlock.Forward,
                      CodeBlock.Wait(1.23),
                      CodeBlock.TurnLeft,
                      CodeBlock.Wait(2.3),
                      CodeBlock.TurnRight,
                      CodeBlock.Wait(1.0),
                      CodeBlock.Stop,
                      CodeBlock.End]
        
        tableView.separatorStyle = .None
        tableView.allowsSelection = false

        tableView.estimatedRowHeight = 89.5
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToProgramming(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codeBlocks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("code", forIndexPath: indexPath) as! CodeBlockCell
        
        // Configure cell
        cell.codeBlock = codeBlocks[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return (indexPath.row != (codeBlocks.count - 1))
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let insertAction = UITableViewRowAction(style: .Normal, title: "↓ Insert") { [unowned self] (_, _) in
            self.chooseCodeBlock() { (block) in
                if block != nil {
                    let newIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.insertCodeBlock(block!, at: newIndexPath, replace: false)
                        self.tableView.setEditing(false, animated: true)
                    });
                }
            }
        }
        insertAction.backgroundColor = UIColor.blueColor()
        
        let replaceAction = UITableViewRowAction(style: .Normal, title: "Edit") { [unowned self] (_, _) in
            self.chooseCodeBlock() { (block) in
                if block != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.insertCodeBlock(block!, at: indexPath, replace: true)
                        self.tableView.setEditing(false, animated: true)
                    });
                }
            }
        }
        
        
        if (indexPath.row == 0) {
            
            return [insertAction]
            
        } else {
            let deleteAction = UITableViewRowAction(style: .Destructive, title: "Delete") { [unowned self] (_, path) in
                self.codeBlocks.removeAtIndex(path.row)
                tableView.deleteRowsAtIndexPaths([path], withRowAnimation: .Fade)
            }
            
            return [deleteAction, insertAction, replaceAction]
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "runCode" {
            let controller = segue.destinationViewController as! RuntimeViewController
            controller.codeBlocks = self.codeBlocks
        }
    }
    
    @IBAction func runCode(sender: UIButton) {
        print(codeBlocks)
        
        performSegueWithIdentifier("runCode", sender: self)
    }
    
    func chooseCodeBlock(handler: (block: CodeBlock?) -> ()) {
        let alertController = UIAlertController(title: "Choose a code block", message: nil, preferredStyle: .ActionSheet)
        
        for block in CodeBlock.allEditableCodeBlocks {
            
            let action = UIAlertAction(title: block.description, style: .Default) { (_) in
                handler(block: block)
            }
            
            alertController.addAction(action)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in
            handler(block: nil)
        }
        
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func insertCodeBlock(block: CodeBlock, at indexPath: NSIndexPath, replace: Bool) {
        switch block {
        case .Wait(_):
            let alertController = UIAlertController(title: "Wait Interval", message: "Time in seconds before next command to be executed, robot will remain running during a wait.", preferredStyle: .Alert)
            
            alertController.addTextFieldWithConfigurationHandler({ (field) in
                field.placeholder = "Time Interval"
                field.keyboardType = .DecimalPad
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let okAction = UIAlertAction(title: "OK", style: .Default) { [unowned self] (action) in
                if let text = alertController.textFields![0].text {
                    if let interval = Double(text) {
                        if interval > 0.0 {
                            let newBlock = CodeBlock.Wait(interval)
                            
                            if replace {
                                self.codeBlocks[indexPath.row] = newBlock
                                (self.tableView.cellForRowAtIndexPath(indexPath) as! CodeBlockCell).codeBlock = newBlock
                            } else {
                                self.codeBlocks.insert(newBlock, atIndex: indexPath.row)
                                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            }
                            
                        }
                    }
                }
                
            }
            alertController.addAction(okAction)
            alertController.preferredAction = okAction
            
            presentViewController(alertController, animated: true, completion: nil)
        default:
            
            if replace {
                codeBlocks[indexPath.row] = block
                (tableView.cellForRowAtIndexPath(indexPath) as! CodeBlockCell).codeBlock = block
            } else {
                codeBlocks.insert(block, atIndex: indexPath.row)
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
        }
    }

}

