//
//  TimelineTableViewController.swift
//  ParseStarterProject
//
//  Created by Panindra Tumkur Seetharamu on 7/5/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TimelineTableViewController: UITableViewController {
    var timeLineData : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
        let username = PFUser.currentUser()!.username
        println(username!)

        if let usrName = username {

        } else {
            var loginAlert = UIAlertController(title: "sign up / login", message: "Please sing up/login", preferredStyle: UIAlertControllerStyle.Alert)
            loginAlert.addTextFieldWithConfigurationHandler{(textField: UITextField!) in
                textField.placeholder = "Your username"
            }

            loginAlert.addTextFieldWithConfigurationHandler{(textField: UITextField!) in
                textField.placeholder = "Your Password"
                textField.secureTextEntry = true
            }

            loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields: Array =  loginAlert.textFields!
                let userNameTxtField : UITextField = textFields[0] as! UITextField
                let passwordTxtField : UITextField = textFields[1] as! UITextField
                PFUser.logInWithUsernameInBackground(userNameTxtField.text, password: passwordTxtField.text, block: { (user: PFUser?, error: NSError?) -> Void in
                    if let use = user  {
                        println("Login successfull")
                    }
                    else {
                        println("Login Failed")
                    }
                })
            }))

            loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields: NSArray =  loginAlert.textFields! as NSArray
                let userNameTxtField = textFields[0] as! UITextField
                let passwordTxtField : UITextField = textFields[1] as! UITextField

                var user :PFUser = PFUser()
                user.username = userNameTxtField.text
                user.password = passwordTxtField.text

                user.signUpInBackgroundWithBlock({ (success : Bool, error : NSError?) -> Void in
                    if !(error != nil) {
                        println("sign up successfull")
                    } else {
                        let errorString = error!.userInfo
                        println(errorString)
                    }
                })
            }))

            self.presentViewController(loginAlert, animated: true, completion: nil)
        }
    }

    func loadData() {
        if timeLineData.count > 0 {
            timeLineData.removeAllObjects()
        }

        var timeData : PFQuery = PFQuery(className: "tweets")
        timeData.findObjectsInBackgroundWithBlock { (objects :[AnyObject]?, error : NSError?) -> Void in
            if (error == nil) {

                for object:PFObject in objects as! [PFObject]{
                    self.timeLineData.addObject(object)
                }

                let array: NSArray = self.timeLineData.reverseObjectEnumerator().allObjects as NSArray
                self.timeLineData = array.mutableCopy() as! NSMutableArray
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return timeLineData.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TweetTableViewCell {
        let cell:TweetTableViewCell = tableView.dequeueReusableCellWithIdentifier("twitterCell", forIndexPath: indexPath) as! TweetTableViewCell
        cell.twitterTxtView.alpha = 0
        cell.userNameLabel.alpha = 0
        cell.timestampLabel.alpha = 0

        let tweet : PFObject = self.timeLineData.objectAtIndex(indexPath.row) as! PFObject
        let tweetUsr : PFQuery = PFUser.query()!
        var dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.timestampLabel.text = dateFormatter.stringFromDate(tweet.createdAt!)

        tweetUsr.whereKey("objectId", equalTo: tweet.objectForKey("tweeter")!.objectId!!)
        tweetUsr.findObjectsInBackgroundWithBlock { (objects : [AnyObject]?, error : NSError?) -> Void in
            if (error == nil) {
                let user : PFUser = (objects as! [PFUser]).last!
                cell.userNameLabel.text =  user.username
            }
        }
        let content: String = tweet.objectForKey("content")! as! String
        cell.twitterTxtView.text = content

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            cell.twitterTxtView.alpha = 1
            cell.userNameLabel.alpha = 1
            cell.timestampLabel.alpha = 1
        })
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
