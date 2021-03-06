//
//  DetailViewController.swift
//  Parsetagram
//
//  Created by Nicole Mitchell on 6/22/16.
//  Copyright © 2016 Nicole Mitchell. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController {
    
    var post: PFObject!
    var username: String!
    var profile = [PFObject]()
    
    @IBOutlet weak var likesCountLabel: UILabel!

    @IBOutlet weak var likeSelector: UIButton!
    
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
    
    @IBOutlet weak var postProfPic: PFImageView!
    @IBOutlet weak var postUsername: UILabel!
    @IBOutlet weak var postImage: PFImageView!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet weak var postTimestamp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //print(post)
            
        let parsedUsername = self.post["author"]
        let parsedImage = self.post["media"] as? PFFile
        let parsedCaption = self.post["caption"]
        let parsedTimestamp = self.post.createdAt! as NSDate
        let likesCount = self.post["likesCount"]
        
        var likers : [String] = []
        if let foo = self.post!["likers"] as? [String] {
            likers = foo
        }
        if likers.contains(PFUser.currentUser()!.username!) {
            likeSelector.selected = true
        } else {
            likeSelector.selected = false
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateString = dateFormatter.stringFromDate(parsedTimestamp)
        print("date\(dateString)")
        
        if (username == nil) {
            postUsername.text = parsedUsername.username
        } else {
            postUsername.text = username
        }
        postImage.file = parsedImage
        postImage.loadInBackground()
        postCaption.text = parsedCaption.description
        postTimestamp.text = dateString
        likesCountLabel.text = "\(likesCount)"
        
    
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: (postUsername.text)!)
        
        query.findObjectsInBackgroundWithBlock { (profile: [PFObject]?, error: NSError?) -> Void in
            if let profile = profile {
                self.profile = profile
                
                if (profile.count != 0) {
                    let user = profile[profile.count-1]
                    let profPic = user["profile_picture"] as? PFFile
                    self.postProfPic.file = profPic
                    self.postProfPic.loadInBackground()
                    
                }
                
                if (self.postProfPic.file == nil) {
                    let profImage = UIImage(named: "profile")
                    
                    self.postProfPic.file = self.getPFFileFromImage(profImage)
                    self.postProfPic.loadInBackground()
                    
                }
                else {
                    
                }
                


                
            } else {
                print(error?.localizedDescription)
            }
            
        }
        print(postProfPic.file)

        
    }
    
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
