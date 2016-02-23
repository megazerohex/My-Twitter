//
//  TweetCell.swift
//  My Twitter
//
//  Created by Jamel Peralta Coss on 2/16/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    //Instance variables
    var tweet_id: String!
    
    //Buttons
    @IBOutlet weak var reTweetButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            userLabel.text = (tweet.user?.name)!
            tweetLabel.text = tweet.text
            handleLabel.text = "@\((tweet.user?.screenname)!)"
            timeLabel.text = "\(tweet.createdAt!)"
            likesLabel.text = tweet.likesCount
            tweet_id = tweet.tweetId
            
            let imageUrl = tweet.user?.profileImageUrl!
            imageProfile.setImageWithURL(NSURL(string: imageUrl!)!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageProfile.layer.cornerRadius = 4
        imageProfile.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet_id)
        reTweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: UIControlState.Normal)

    }
    
}
