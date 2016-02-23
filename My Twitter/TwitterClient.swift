//
//  TwitterClient.swift
//  My Twitter
//
//  Created by Jamel Peralta Coss on 2/15/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "S59TrZ6ggt1LHXjCt39RwOcIT"
let twitterConsumerSecret = "X3wGz4sExjYgLRnc09cUgSJu1SQYtbGODFrDOLwvCEUccJ4N9N"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    //Method for login and request a token
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //This clean the token if there is another token again
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        //This token gives permission to the user, to use the information of twitter
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oath"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("got the request token")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)  //this open the webBrowser to ask for permission
            },
            failure: { (error: NSError!) -> Void in
                print("fail to get token")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
    
    //Method to gather the information from the user after the login permission (transition from web to app)
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: {(accessToken: BDBOAuth1Credential!) -> Void in
                print("got access token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                //For accessing the profile data dictionary
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: {(operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
    
                        //print("user: \(response)")
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        print("username: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)
                        
                    }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                        
                        print("error getting user")
                        self.loginCompletion?(user: nil, error: error)
                        
                })
                
            }) {(error: NSError!) -> Void in
                print("Failed to receive acces token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    /*
    *
    *
    *    THESE ARE METHODS FOR GETTING INFO FROM TWITTER!!!
    *
    */
    
    //Method for accessing the home timeline dictionary
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweet: [Tweet]?, error: NSError?)-> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params,
            success: { (operation: NSURLSessionDataTask?, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                for tweet in tweets {
                    print("tweet: \(tweet.user?.profileImageUrl!)")
                }
                completion(tweet: tweets, error: nil)
            },
            
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Failed to get the infomation")
                completion(tweet: nil, error: error)
                self.loginCompletion!(user: nil, error: error)
        })
        
    }
    
    func userTimeline(screenname: String, completion: (tweet: [Tweet]?, error: NSError?)-> ()) {
        GET("1.1/statuses/user_timeline.json?screen_name=\(screenname)", parameters: nil,
            success: { (operation: NSURLSessionDataTask?, response: AnyObject?) -> Void in
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweet: tweets, error: nil)
            },
            
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Error retrieving info: \(error)")
                
                completion(tweet: nil, error: error)
                self.loginCompletion!(user: nil, error: error)
        })
        
    }
    
    /*
    *
    *
    *    THESE ARE METHODS FOR POSTING IN TWITTER!!!
    *
    */
    
    func tweet(tweetText: String) {
        let escapedText = (tweetText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))!
        POST("1.1/statuses/update.json?status=\(escapedText)", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("You tweeted!!")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Reply error:\(error)")
        })
        
    }
    
    func retweet(id: String) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil,
            success: {(operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print ("rt")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("RT error: \(error)")
        })
    }
    
    func reply(tweetId: String, tweetText: String) {
        let escapedText = (tweetText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))!
        print("1.1/statuses/update.json?status=\(escapedText)&in_reply_to_status_id=\(tweetId)")
        POST("1.1/statuses/update.json?status=\(escapedText)&in_reply_to_status_id=\(tweetId)", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("replied")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Reply error:\(error)")
        })
        
    }
    
    func favorite(id: String) {
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("successful fav")
            }) { (opreation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Fav error: \(error)")
        }
    }

}
