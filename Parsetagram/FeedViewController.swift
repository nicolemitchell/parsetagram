//
//  FeedViewController.swift
//  Parsetagram
//
//  Created by Nicole Mitchell on 6/20/16.
//  Copyright © 2016 Nicole Mitchell. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var profile = [PFObject]()

    
    
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var FeedTableView: UITableView!
    
    @IBAction func logoutButton(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
        
        self.performSegueWithIdentifier("logoutSegue", sender: nil)
    }
    
    //@IBOutlet weak var postImage: UIImageView!
    //@IBOutlet weak var postCaption: UILabel!
    
    var posts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        FeedTableView.dataSource = self
        FeedTableView.delegate = self
        
        self.refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        FeedTableView.insertSubview(refreshControl, atIndex: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, FeedTableView.contentSize.height, FeedTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        FeedTableView.addSubview(loadingMoreView!)
        
        var insets = FeedTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        FeedTableView.contentInset = insets
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        fetchPosts()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame:CGRect = tableView.frame
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
        let label = UILabel(frame: CGRectMake(75, 25, tableView.frame.size.width, 18))
        let image = PFImageView(frame: CGRectMake(35, 20, 30, 30))
        label.font = UIFont.systemFontOfSize(17)
        let post = posts[section]
        let user = post["author"].username
        label.text = user
        view.addSubview(label)
        view.addSubview(image)
        view.backgroundColor = UIColor.whiteColor() // Set your background color
        
        
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: (label.text)!)
        
        query.findObjectsInBackgroundWithBlock { (profile: [PFObject]?, error: NSError?) -> Void in
            if let profile = profile {
                self.profile = profile
                
                if (profile.count != 0) {
                    let user = profile[profile.count-1]
                    let profPic = user["profile_picture"] as? PFFile
                    image.file = profPic
                    image.loadInBackground()
                    
                }
                
                if (image.file == nil) {
                    let profImage = UIImage(named: "profile")
                    
                    image.file = self.getPFFileFromImage(profImage)
                    image.loadInBackground()
                    
                }
                else {
                }
                
            } else {
                print(error?.localizedDescription)
            }
        }
        
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 61.0
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
    
    
    
    
//    func tableView(tableView: UITableView, )
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.alpha = 0
//        UIView.animateWithDuration(1.25) {
//            cell.alpha = 1.0
//        }
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! postCell
        
        let post = posts[indexPath.section]
        cell.post = post
        
        let parsedImage = post["media"] as? PFFile
        let parsedCaption = post["caption"]
        let likesCount = post["likesCount"]
        
        cell.photoPost.file = parsedImage
        cell.captionPost.text = parsedCaption.description
        cell.photoPost.loadInBackground()
        cell.likesCountLabel.text = "\(likesCount)"
        var likers : [String] = []
        if let foo = post["likers"] as? [String] {
            likers = foo
        }
        if likers.contains(PFUser.currentUser()!.username!) {
            cell.likeSelector.selected = true
        } else {
            cell.likeSelector.selected = false
        }
        
        
        
       
    
    
        return cell
    }
    
    func fetchPosts() {
        
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.FeedTableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    

    func loadMoreData() {
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.skip = posts.count
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.posts.appendContentsOf(posts)
                self.isMoreDataLoading = false
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                self.FeedTableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = FeedTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - FeedTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && FeedTableView.dragging) {
                
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, FeedTableView.contentSize.height, FeedTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "feedDetailSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = FeedTableView.indexPathForCell(cell)
            let post = posts[indexPath!.section]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            
            detailViewController.post = post

        }
        
    }
    

}
