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
        
        codeBlocks = [CodeBlock.Forward,
                      CodeBlock.Wait(1.23),
                      CodeBlock.TurnLeft,
                      CodeBlock.Wait(2.3),
                      CodeBlock.TurnRight,
                      CodeBlock.Wait(1.0),
                      CodeBlock.Stop]
        
        tableView.separatorStyle = .None

        tableView.estimatedRowHeight = 89.5
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let insertAction = UITableViewRowAction(style: .Normal, title: "↓ Insert") { (_, _) in
            NSLog("Insert")
        }
        
        let deleteAction = UITableViewRowAction(style: .Destructive, title: "Delete") { [unowned self] (_, path) in
            self.codeBlocks.removeAtIndex(path.row)
            tableView.deleteRowsAtIndexPaths([path], withRowAnimation: .Fade)
        }
        
        return [deleteAction, insertAction]
    }
    
    @IBAction func runCode(sender: UIButton) {
        
    }

}

