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
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var screenname: String?
    
    //Contructor
    init(dictionary: NSDictionary) {
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        screenname = dictionary["screenname"] as? String
        //favorites = Retweet(dictionary: <#T##NSDictionary#>)
        //retweets = Favorite(dictionary: <#T##NSDictionary#>)
        
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
