//
//  CodeBlockCell.swift
//  TeachBot
//
//  Created by Edward Guo on 2016-08-30.
//  Copyright © 2016 Pei Liang Guo. All rights reserved.
//

import UIKit

class CodeBlockCell: UITableViewCell {
    
    @IBOutlet weak var insertButton: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var colorBackgroundView: UIView!
    @IBOutlet weak var arrowView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    
    var codeBlock: CodeBlock? {
        didSet {
            if codeBlock != nil {
                configureColor()
                configureLabel()
                configureIcon()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func insertCodeBlockBelow(sender: UIButton) {
        
    }
    
    func configureLabel() {
        switch codeBlock! {
        case .Stop:
            label.text = "Stop"
        case .Forward:
            label.text = "Forward"
        case .Backward:
            label.text = "Backward"
        case .TurnLeft:
            label.text = "Turn Left"
        case .TurnRight:
            label.text = "Turn Right"
        case.Wait(let interval):
            label.text = NSString(format: "Wait %.1f s", interval) as String
        }
    }
    
    func configureIcon() {
        let imageName: String
        
        switch codeBlock! {
        case .Stop:
            imageName = "Stop"
        case .Forward:
            imageName = "Forward"
        case .Backward:
            imageName = "Backward"
        case .TurnLeft:
            imageName = "TurnLeft"
        case .TurnRight:
            imageName = "TurnRight"
        case.Wait(_):
            imageName = "Timer"
        }
        
        iconView.image = UIImage(named: imageName)
    }
    
    func configureColor() {
        let imageName: String
        
        switch codeBlock! {
        case .Forward, .Backward:
            colorBackgroundView.backgroundColor = UIColor(red: 0.18, green: 0.8, blue: 0.443, alpha: 1.0)
            imageName = "GreenTriangle"
        case .TurnLeft, .TurnRight:
            colorBackgroundView.backgroundColor = UIColor(red: 0.102, green: 0.737, blue: 0.612, alpha: 1.0)
            imageName = "GreenTriangle"
        case .Stop:
            colorBackgroundView.backgroundColor = UIColor(red: 0.906, green: 0.298, blue: 0.235, alpha: 1.0)
            imageName = "GreenTriangle"
        case .Wait(_):
            colorBackgroundView.backgroundColor = UIColor(red: 0.945, green: 0.769, blue: 0.059, alpha: 1.0)
            imageName = "GreenTriangle"
        }
        
        arrowView.image = UIImage(named: imageName)
    }
}
