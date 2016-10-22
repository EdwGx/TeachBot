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
        
        codeBlocks = [CodeBlock.start,
                      CodeBlock.forward,
                      CodeBlock.wait(1.23),
                      CodeBlock.turnLeft,
                      CodeBlock.wait(2.3),
                      CodeBlock.turnRight,
                      CodeBlock.wait(1.0),
                      CodeBlock.stop,
                      CodeBlock.end]
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false

        tableView.estimatedRowHeight = 89.5
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToProgramming(_ segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codeBlocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath) as! CodeBlockCell
        
        // Configure cell
        cell.codeBlock = codeBlocks[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return ((indexPath as NSIndexPath).row != (codeBlocks.count - 1))
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let insertAction = UITableViewRowAction(style: .normal, title: "↓ Insert") { [unowned self] (_, _) in
            self.chooseCodeBlock() { (block) in
                if block != nil {
                    let newIndexPath = IndexPath(row: (indexPath as NSIndexPath).row + 1, section: (indexPath as NSIndexPath).section)
                    DispatchQueue.main.async(execute: {
                        self.insertCodeBlock(block!, at: newIndexPath, replace: false)
                        self.tableView.setEditing(false, animated: true)
                    });
                }
            }
        }
        insertAction.backgroundColor = UIColor.blue
        
        let replaceAction = UITableViewRowAction(style: .normal, title: "Edit") { [unowned self] (_, _) in
            self.chooseCodeBlock() { (block) in
                if block != nil {
                    DispatchQueue.main.async(execute: {
                        self.insertCodeBlock(block!, at: indexPath, replace: true)
                        self.tableView.setEditing(false, animated: true)
                    });
                }
            }
        }
        
        
        if ((indexPath as NSIndexPath).row == 0) {
            
            return [insertAction]
            
        } else {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self] (_, path) in
                self.codeBlocks.remove(at: (path as NSIndexPath).row)
                tableView.deleteRows(at: [path], with: .fade)
            }
            
            return [deleteAction, insertAction, replaceAction]
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "runCode" {
            let controller = segue.destination as! RuntimeViewController
            controller.codeBlocks = self.codeBlocks
        }
    }
    
    @IBAction func runCode(_ sender: UIButton) {
        print(codeBlocks)
        
        performSegue(withIdentifier: "runCode", sender: self)
    }
    
    func chooseCodeBlock(_ handler: @escaping (_ block: CodeBlock?) -> ()) {
        let alertController = UIAlertController(title: "Choose a code block", message: nil, preferredStyle: .actionSheet)
        
        for block in CodeBlock.allEditableCodeBlocks {
            
            let action = UIAlertAction(title: block.description, style: .default) { (_) in
                handler(block)
            }
            
            alertController.addAction(action)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            handler(nil)
        }
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func insertCodeBlock(_ block: CodeBlock, at indexPath: IndexPath, replace: Bool) {
        switch block {
        case .wait(_):
            let alertController = UIAlertController(title: "Wait Interval", message: "Time in seconds before next command to be executed, robot will remain running during a wait.", preferredStyle: .alert)
            
            alertController.addTextField(configurationHandler: { (field) in
                field.placeholder = "Time Interval"
                field.keyboardType = .decimalPad
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] (action) in
                if let text = alertController.textFields![0].text {
                    if let interval = Double(text) {
                        if interval > 0.0 {
                            let newBlock = CodeBlock.wait(interval)
                            
                            if replace {
                                self.codeBlocks[(indexPath as NSIndexPath).row] = newBlock
                                (self.tableView.cellForRow(at: indexPath) as! CodeBlockCell).codeBlock = newBlock
                            } else {
                                self.codeBlocks.insert(newBlock, at: (indexPath as NSIndexPath).row)
                                self.tableView.insertRows(at: [indexPath], with: .fade)
                            }
                            
                        }
                    }
                }
                
            }
            alertController.addAction(okAction)
            alertController.preferredAction = okAction
            
            present(alertController, animated: true, completion: nil)
        default:
            
            if replace {
                codeBlocks[(indexPath as NSIndexPath).row] = block
                (tableView.cellForRow(at: indexPath) as! CodeBlockCell).codeBlock = block
            } else {
                codeBlocks.insert(block, at: (indexPath as NSIndexPath).row)
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
        }
    }

}

