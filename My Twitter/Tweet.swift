//
//  Tweet.swift
//  My Twitter
//
//  Created by Jamel Peralta Coss on 2/16/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    //instance variables
    var user: User?
    var tweetId: String?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var screenname: String?
    var likesCount: String?
    
    //for details controller
    var retweetCount: String?
    var favoriteCount: String?
    
    //Contructor
    init(dictionary: NSDictionary) {
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        tweetId = (dictionary["id_str"] as! String?)!
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        screenname = dictionary["screenname"] as? String
        likesCount = "\((dictionary["favorite_count"])!)"
        //favorites = Retweet(dictionary: <#T##NSDictionary#>)
        //retweets = Favorite(dictionary: <#T##NSDictionary#>)
        
        //for details controller
        retweetCount = "\((dictionary["retweet_count"])!)"
        favoriteCount = "\((dictionary["favorite_count"])!)"
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    //method for storing all the NSdictionary of tweets
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
}
