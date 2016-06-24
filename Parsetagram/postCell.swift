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
    
    
    @IBOutlet weak var heartImage: UIImageView!
    
    @IBOutlet weak var photoPost: PFImageView!
    @IBOutlet weak var captionPost: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBAction func likeButton(sender: AnyObject) {
        
        if post != nil {
            var likers : [String] = []
            if let foo = self.post!["likers"] as? [String] {
                likers = foo
            }
            
            
            var likesCount = self.post!["likesCount"] as! Int
            if likers.contains(PFUser.currentUser()!.username!) {
                let index = likers.indexOf(PFUser.currentUser()!.username!)
                likers.removeAtIndex(index!)
                likesCount -= 1
                self.post!["likesCount"] = likesCount
                likesCountLabel.text = "\(likesCount)"
                heartImage.hidden = true
                
            } else {
                likers.append(PFUser.currentUser()!.username!)
                likesCount += 1
                self.post!["likesCount"] = likesCount
                likesCountLabel.text = "\(likesCount)"
                heartImage.hidden = false
                
            }
            self.post!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                print("woo")
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
