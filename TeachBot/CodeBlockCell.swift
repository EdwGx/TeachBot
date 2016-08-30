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
}
