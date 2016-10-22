//
//  CodeBlockCell.swift
//  TeachBot
//
//  Created by Edward Guo on 2016-08-30.
//  Copyright © 2016 Pei Liang Guo. All rights reserved.
//

import UIKit

class CodeBlockCell: UITableViewCell {
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func insertCodeBlockBelow(_ sender: UIButton) {
        
    }
    
    func configureLabel() {
        label.text = codeBlock?.description
    }
    
    func configureIcon() {
        let imageName: String
        
        switch codeBlock! {
        case .stop:
            imageName = "Stop"
        case .forward:
            imageName = "Forward"
        case .backward:
            imageName = "Backward"
        case .turnLeft:
            imageName = "TurnLeft"
        case .turnRight:
            imageName = "TurnRight"
        case .start:
            imageName = "StartIcon"
        case .end:
            imageName = "EndIcon"
        case.wait(_):
            imageName = "Timer"
        }
        
        iconView.image = UIImage(named: imageName)
    }
    
    func configureColor() {
        
        switch codeBlock! {
        case .forward, .backward:
            colorBackgroundView.backgroundColor = UIColor(red: 0.18, green: 0.8, blue: 0.443, alpha: 1.0)
            arrowView.image = UIImage(named: "GreenTriangle")
        case .turnLeft, .turnRight:
            colorBackgroundView.backgroundColor = UIColor(red: 0.102, green: 0.737, blue: 0.612, alpha: 1.0)
            arrowView.image = UIImage(named: "TurquoiseTriangle")
        case .stop:
            colorBackgroundView.backgroundColor = UIColor(red: 0.906, green: 0.298, blue: 0.235, alpha: 1.0)
            arrowView.image = UIImage(named: "RedTriangle")
        case .start:
            colorBackgroundView.backgroundColor = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
            arrowView.image = UIImage(named: "GreyTriangle")
        case .end:
            colorBackgroundView.backgroundColor = UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.0)
            arrowView.image = nil
        case .wait(_):
            colorBackgroundView.backgroundColor = UIColor(red: 0.945, green: 0.769, blue: 0.059, alpha: 1.0)
            arrowView.image = UIImage(named: "YellowTriangle")
        }
        
        
    }
}
