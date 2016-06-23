//
//  ProfileViewController.swift
//  Parsetagram
//
//  Created by Nicole Mitchell on 6/20/16.
//  Copyright © 2016 Nicole Mitchell. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var profilePic: PFImageView!
    
    @IBOutlet weak var ProfileCollectionView: UICollectionView!
    
    @IBAction func changeProfilePic(sender: AnyObject) {
        tabBarController?.selectedIndex = 1
    }
    
    @IBOutlet weak var username: UILabel!
    var posts = [PFObject]()
    var profile = [PFObject]()
    
    
    @IBAction func logoutButton(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
        
        self.performSegueWithIdentifier("logoutSegue", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        ProfileCollectionView.delegate = self
        ProfileCollectionView.dataSource = self
        username.text = PFUser.currentUser()?.username

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
        
        fetchProfilePic()
        
        if (profile.count != 0) {
            let user = profile[profile.count-1]
            let parsedImage = user["profile_picture"] as? PFFile
            profilePic.file = parsedImage
            profilePic.loadInBackground()

        }
        
        if (profilePic.file == nil) {
            let profImage = UIImage(named: "profile")
            
            profilePic.file = getPFFileFromImage(profImage)
        }
        else {
            
        }
        
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
    
    func fetchProfilePic() {
        print("fetching prof pic")
        let query = PFQuery(className: "_User")
        print("query user")
        query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)

        
        query.findObjectsInBackgroundWithBlock { (profile: [PFObject]?, error: NSError?) -> Void in
            if let profile = profile {
                self.profile = profile
                print(profile)
                    
            } else {
                print(error?.localizedDescription)
            }

        }
        
    
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("profileCell", forIndexPath: indexPath) as! profileCell
        
        
        let post = posts[indexPath.row]
        let parsedImage = post["media"] as? PFFile
        cell.profileCellImage.file = parsedImage
        cell.profileCellImage.loadInBackground()
        
        return cell
    }
    

    func fetchPosts() {
        // construct query
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.ProfileCollectionView.reloadData()
                
            } else {
                print(error?.localizedDescription)
            }
        }
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
