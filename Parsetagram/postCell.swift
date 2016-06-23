//
//  postCell.swift
//  Parsetagram
//
//  Created by Nicole Mitchell on 6/21/16.
//  Copyright © 2016 Nicole Mitchell. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class postCell: UITableViewCell {

    @IBOutlet weak var photoPost: PFImageView!
    @IBOutlet weak var captionPost: UILabel!
    
    
    var query = PFQuery(className: "Post")
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        query.getObjectInBackgroundWithId("4Qwr0oFo7a") {
            (post: PFObject?, error: NSError?) -> Void in
            if error == nil {
                
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
