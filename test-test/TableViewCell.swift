//
//  TableViewCell.swift
//  test-test
//
//  Created by Jason Gindi on 12/11/16.
//  Copyright © 2016 JasonGindi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {


    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
