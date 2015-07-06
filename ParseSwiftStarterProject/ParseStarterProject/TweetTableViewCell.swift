//
//  TeeetTableViewCell.swift
//  ParseStarterProject
//
//  Created by Panindra Tumkur Seetharamu on 7/5/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var twitterTxtView: UITextView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
