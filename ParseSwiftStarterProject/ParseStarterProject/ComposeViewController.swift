//
//  ComposeViewController.swift
//  ParseStarterProject
//
//  Created by Panindra Tumkur Seetharamu on 7/5/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charRmaningLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        tweetTextView.layer.backgroundColor = UIColor.blackColor().CGColor
        tweetTextView.layer.borderWidth = 0.5
        tweetTextView.layer.cornerRadius = 5
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendTweet(sender: UIBarButtonItem) {
        var tweet: PFObject = PFObject(className: "tweets")
        tweet["content"] = tweetTextView.text
        tweet["tweeter"] = PFUser.currentUser()

        tweet.saveInBackground()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var newLength : Int = (textView.text as NSString).length + (text as NSString).length - range.length
        let remainingChars = 140 - newLength

        charRmaningLabel.text = "\(remainingChars)"

        return (newLength > 140) ? false : true
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
