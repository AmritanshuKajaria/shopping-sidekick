//
//  SearchResultsTableViewCell.swift
//  shopping-sidekick
//
//  Created by Jason Gindi on 12/11/16.
//  Copyright © 2016 Amritanshu Kajaria. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
