//
//  TweetsViewController.swift
//  My Twitter
//
//  Created by Jamel Peralta Coss on 2/16/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    //instance variable that contains all the tweets
    var tweets: [Tweet]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 10

        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        // Initialize a UIRefreshControl ------> thats the circle for loading and refreshing the app
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
    }
    
    //Method for refreching
    func refreshControlAction(refreshControl: UIRefreshControl) {
        //Connect to the API to have the last update
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        //update the collection data source
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        cell.tweetLabel.sizeToFit()
        
        return cell
    }
    
    //When you logout from the account
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "replySegue" {
            print("started replying")
            let button = sender as! UIButton
            let buttonFrame = button.convertRect(button.bounds, toView: self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(buttonFrame.origin) {
                let navigationController = segue.destinationViewController as! UINavigationController
                let createController = navigationController.topViewController as! CreateViewController
                
                let selectedRow = indexPath.row as NSInteger
                
                let tweet = tweets![selectedRow]
                let replyHandle  = "@\((tweet.user?.screenname!)!) " as String
                
                createController.tweetId = (tweet.tweetId!)
                createController.replyTo = replyHandle
                createController.isReply = true
            }
        }
        
        if segue.identifier == "profileSegue" {
            let button = sender as! UIButton
            let buttonFrame = button.convertRect(button.bounds, toView: self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(buttonFrame.origin) {
                let profileController = segue.destinationViewController as! ProfileViewController
                
                let selectedRow = indexPath.row as NSInteger
                
                profileController.tweets = tweets
                profileController.index = selectedRow
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        
        if segue.identifier == "detailControllerSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                
                let detailController = segue.destinationViewController as! DetailsViewController
                
                let selectedRow = indexPath.row as NSInteger
                
                detailController.tweets = tweets
                detailController.index = selectedRow
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        
    }


}
