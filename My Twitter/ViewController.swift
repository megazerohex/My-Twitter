//
//  ViewController.swift
//  My Twitter
//
//  Created by Jamel Peralta Coss on 2/15/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Method for login
    @IBAction func onLogin(sender: AnyObject) {
        //If the login is success, then go the tweetView, else login again
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
                //for performing a segue
            } else {
                //error
            }
        }
    }

}

