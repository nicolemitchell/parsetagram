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

    var post: PFObject?
    
        
    @IBOutlet weak var likeSelector: UIButton!
    @IBOutlet weak var photoPost: PFImageView!
    @IBOutlet weak var captionPost: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBAction func likeButton(sender: UIButton) {
        
        if post != nil {
            var likers : [String] = []
            if let foo = self.post!["likers"] as? [String] {
                likers = foo
            }
            
            
            var likesCount = self.post!["likesCount"] as! Int
            if likeSelector.selected == true {
                let index = likers.indexOf(PFUser.currentUser()!.username!)
                likers.removeAtIndex(index!)
                self.post!["likers"] = likers
                print(likers)
                likesCount -= 1
                self.post!["likesCount"] = likesCount
                likesCountLabel.text = "\(likesCount)"
                sender.selected = false
                
            } else {
                likers.append(PFUser.currentUser()!.username!)
                print(likers)
                self.post!["likers"] = likers
                likesCount += 1
                self.post!["likesCount"] = likesCount
                likesCountLabel.text = "\(likesCount)"
                sender.selected = true
                
            }
            self.post!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                print("")
            })
        }
        
        
        
    }
    
    
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
