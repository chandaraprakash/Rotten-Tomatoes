//
//  MovieTableViewCell.swift
//  Rotten Tomatoes
//
//  Created by Kumar, Chandaraprakash on 9/15/14.
//  Copyright (c) 2014 chantech. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {


    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
