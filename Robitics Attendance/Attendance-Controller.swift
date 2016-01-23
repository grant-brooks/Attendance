//
//  Attendance-Controller.swift
//  Robotics Attendance
//
//  Created by Grant Goodman on 10/2/15.
//  Copyright © 2016 NEOTechnica Corporation. All rights reserved.
//

import UIKit
import Parse

class AC: UIViewController
{
    var presentOnCurrentDateBoolean: Bool! = false
    var totalAttendanceInteger: Int! = 0
    var signInDate: NSDate! = NSDate()
    var daysAgoInformationWasCurrentInteger: Int! = 0
    
    var sessionTimeAlert: UIAlertController!
    
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var signOutWCB: WCB!
    
    override func viewDidLoad()
    {
//        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            
//            self.firstEncloserView.alpha = 0.0
//            self.firstTitleView.alpha = 0.0
//            
//            self.secondEncloserView.alpha = 0.0
//            self.secondTitleView.alpha = 0.0
//            
//            self.thirdEncloserView.alpha = 0.0
//            self.thirdTitleView.alpha = 0.0
//            
//            self.studentNameLabel.alpha = 0.0
//            
//            }, completion: nil)
        
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let buildIdentifier = appDelegate.buildIdentifier
        
        buildLabel.text = buildIdentifier!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        
        let signInDateString = String(PFUser.currentUser()!.objectForKey("signInDate") as! NSDate)
        let currentDateString = String(NSDate())
        
        let startDate: NSDate = dateFormatter.dateFromString(signInDateString)!
        let endDate: NSDate = dateFormatter.dateFromString(currentDateString)!
        
        let finalDateFormatter = NSDateFormatter()
        finalDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDateAsString: NSString = finalDateFormatter.stringFromDate(startDate)
        let endDateAsString: NSString = finalDateFormatter.stringFromDate(endDate)
        
        if startDateAsString == endDateAsString
        {
            presentOnCurrentDateBoolean = true
        }
        
        print("Present on Current Date: '\(presentOnCurrentDateBoolean)'.")
        
        totalAttendanceInteger = PFUser.currentUser()!.objectForKey("totalAttendance") as! Int
        signInDate = PFUser.currentUser()!.objectForKey("signInDate") as! NSDate
        
        print("Total Attendance: '\(totalAttendanceInteger)'.")
        print("Sign In Date: '\(signInDate)'.")
        
        setButtonElementsForWhiteCircularButton(signOutWCB, buttonTitle: "SIGN OUT", buttonTarget: "signOutUser", buttonEnabled: true)
    }
    
    ///Function that sets the background image on a UIView.
    func setBackgroundImageForView(chosenView: UIView!, backgroundImageName: String!)
    {
        UIGraphicsBeginImageContext(chosenView.frame.size)
        
        UIImage(named: backgroundImageName)?.drawInRect(chosenView.bounds)
        
        let imageToSet: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        chosenView.backgroundColor = UIColor(patternImage: imageToSet)
    }
    
    ///Function that rounds corners on any desired object. Accepts 'left' and 'right' as strings.
    func roundCornersOnObject(objectToRound: AnyObject!, sideToRound: String!)
    {
        var topCorner: UIRectCorner!
        var bottomCorner: UIRectCorner!
        
        if sideToRound.noWhiteSpaceLowerCaseString == "left"
        {
            topCorner = UIRectCorner.TopLeft
            bottomCorner = UIRectCorner.BottomLeft
        }
        else if sideToRound.noWhiteSpaceLowerCaseString == "right"
        {
            topCorner = UIRectCorner.TopRight
            bottomCorner = UIRectCorner.BottomRight
        }
        
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: objectToRound!.bounds,
            byRoundingCorners: [topCorner, bottomCorner],
            cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        
        maskLayer.frame = objectToRound!.bounds
        maskLayer.path = maskPath.CGPath
        
        objectToRound!.layer.mask = maskLayer
        objectToRound!.layer.masksToBounds = false
        objectToRound!.view?.clipsToBounds = true
    }
    
    func setButtonElementsForWhiteCircularButton(circularButton: WCB, buttonTitle: String, buttonTarget: String?, buttonEnabled: Bool)
    {
        if buttonEnabled == true
        {
            circularButton.layer.borderColor = UIColor.whiteColor().CGColor
            circularButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            circularButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            
            circularButton.enabled = true
            circularButton.userInteractionEnabled = true
        }
        else
        {
            circularButton.layer.borderColor = UIColor.grayColor().CGColor
            circularButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            circularButton.enabled = false
            circularButton.userInteractionEnabled = false
        }
        
        
        circularButton.layer.borderWidth = 1.0
        circularButton.layer.cornerRadius = 5.0
        circularButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        circularButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        
        if buttonTarget != nil
        {
            let buttonTargetSelector: Selector = NSSelectorFromString(buttonTarget!)
            circularButton.addTarget(self, action: buttonTargetSelector, forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func setButtonElementsForBlackCircularButton(circularButton: BCB, buttonTitle: String, buttonTarget: String?, buttonEnabled: Bool)
    {
        if buttonEnabled == true
        {
            circularButton.layer.borderColor = UIColor.blackColor().CGColor
            circularButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            circularButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            
            circularButton.enabled = true
            circularButton.userInteractionEnabled = true
        }
        else
        {
            circularButton.layer.borderColor = UIColor.grayColor().CGColor
            circularButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            circularButton.enabled = false
            circularButton.userInteractionEnabled = false
        }
        
        
        circularButton.layer.borderWidth = 1.0
        circularButton.layer.cornerRadius = 5.0
        circularButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        circularButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        
        if buttonTarget != nil
        {
            let buttonTargetSelector: Selector = NSSelectorFromString(buttonTarget!)
            circularButton.addTarget(self, action: buttonTargetSelector, forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        if daysAgoInformationWasCurrentInteger == 0 || daysAgoInformationWasCurrentInteger != 0
        {
            let notAttendedAlert = UIAlertController(title: "Update Attendance?", message: "You have not updated your attendance yet today. \n\n Would you like to mark yourself as present for today?", preferredStyle: UIAlertControllerStyle.Alert)
            
            notAttendedAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                
                PFUser.currentUser()!.setObject(NSDate(), forKey: "signInDate")
                PFUser.currentUser()!.setObject(PFUser.currentUser()!.objectForKey("totalAttendance") as! Int + 1, forKey: "totalAttendance")
                
                PFUser.currentUser()!.saveInBackgroundWithBlock
                    {
                        (savedSuccessfully: Bool, occurredError: NSError?) -> Void in
                        
                        if savedSuccessfully
                        {
                            print("The object was saved successfully.")
                        }
                            
                        else
                        {
                            print("An error occurred while saving data the query.")
                            print("Technical Information: '\(occurredError)'.")
                        }
                }
            }))
            
            notAttendedAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            presentViewController(notAttendedAlert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func signOutUser()
    {
        let currentDateAndTime = NSDate()
        
        var signInDate = PFUser.currentUser()?.valueForKey("signInDate") as! NSDate
        var signOutDate = PFUser.currentUser()?.valueForKey("signOutDate") as! NSDate
        
        let totalSessionTimeInSeconds = currentDateAndTime.secondsFrom(signInDate)
        
        let totalTimeLogged = PFUser.currentUser()?.valueForKey("totalTimeLogged") as! Int
        
        PFUser.currentUser()?.setValue(currentDateAndTime, forKey: "signOutDate")
        PFUser.currentUser()?.setValue(totalTimeLogged + totalSessionTimeInSeconds, forKey: "totalTimeLogged")
        PFUser.currentUser()!.saveInBackgroundWithBlock
            {
                (savedSuccessfully: Bool, occurredError: NSError?) -> Void in
                
                if savedSuccessfully
                {
                    print("The object was saved successfully.")
                }
                    
                else
                {
                    print("An error occurred while saving data the query.")
                    print("Technical Information: '\(occurredError)'.")
                }
        }
        
        signInDate = PFUser.currentUser()?.valueForKey("signInDate") as! NSDate
        signOutDate = PFUser.currentUser()?.valueForKey("signOutDate") as! NSDate
        
        let sessionTimeInHours = signOutDate.hoursFrom(signInDate)
        let sessionTimeInMinutes = signOutDate.minutesFrom(signInDate) - signOutDate.hoursFrom(signInDate) * 60
        let sessionTimeInSeconds = signOutDate.secondsFrom(signInDate) - signOutDate.minutesFrom(signInDate) * 60
        
        if sessionTimeInHours == 0
        {
            if sessionTimeInMinutes == 0
            {
                if sessionTimeInSeconds == 1
                {
                    self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInSeconds) second.", preferredStyle: UIAlertControllerStyle.Alert)
                }
                else
                {
                    self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInSeconds) seconds.", preferredStyle: UIAlertControllerStyle.Alert)
                }
            }
            else if sessionTimeInMinutes == 1
            {
                if sessionTimeInSeconds == 1
                {
                    self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInMinutes) minute and \(sessionTimeInSeconds) second.", preferredStyle: UIAlertControllerStyle.Alert)
                }
                else
                {
                    self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInMinutes) minute and \(sessionTimeInSeconds) seconds.", preferredStyle: UIAlertControllerStyle.Alert)
                }
            }
            else
            {
                if sessionTimeInSeconds == 1
                {
                    self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInMinutes) minutes and \(sessionTimeInSeconds) second.", preferredStyle: UIAlertControllerStyle.Alert)
                }
                else
                {
                    self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInMinutes) minutes and \(sessionTimeInSeconds) seconds.", preferredStyle: UIAlertControllerStyle.Alert)
                }
            }
        }
        else if sessionTimeInHours == 1
        {
            if sessionTimeInMinutes == 0
            {
                self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInHours) hour.", preferredStyle: UIAlertControllerStyle.Alert)
            }
            else if sessionTimeInMinutes == 1
            {
                self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInHours) hour and \(sessionTimeInMinutes) minute.", preferredStyle: UIAlertControllerStyle.Alert)
            }
            else
            {
                self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInHours) hour and \(sessionTimeInMinutes) minutes.", preferredStyle: UIAlertControllerStyle.Alert)
            }
        }
        else
        {
            if sessionTimeInMinutes == 0
            {
                self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInHours) hours.", preferredStyle: UIAlertControllerStyle.Alert)
            }
            else if sessionTimeInMinutes == 1
            {
                self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInHours) hours and \(sessionTimeInMinutes) minute.", preferredStyle: UIAlertControllerStyle.Alert)
            }
            else
            {
                self.sessionTimeAlert = UIAlertController(title: "Time Allotted", message: "You were in robotics for \(sessionTimeInHours) hours and \(sessionTimeInMinutes) minutes.", preferredStyle: UIAlertControllerStyle.Alert)
            }
        }
        
        sessionTimeAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { (action: UIAlertAction!) in
            
            self.performSegueWithIdentifier("backToLoginSegueFromAttendance", sender: self)
        }))
        
        presentViewController(sessionTimeAlert, animated: true, completion: nil)
        
        PFUser.logOut()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "backToLoginSegueFromAttendance"
        {
            //let destinationViewController = segue.destinationViewController as! ViewController
        }
        
        if segue.identifier == "backToMenuSegueFromAttendance"
        {
            //let destinationViewController = segue.destinationViewController as! MEC
        }
    }
}

extension NSDate
{
    func yearsFrom(date:NSDate) -> Int
    {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: []).year
    }
    
    func monthsFrom(date:NSDate) -> Int
    {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: []).month
    }
    
    func weeksFrom(date:NSDate) -> Int
    {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    
    func daysFrom(date:NSDate) -> Int
    {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date, toDate: self, options: []).day
    }
    
    func hoursFrom(date:NSDate) -> Int
    {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: self, options: []).hour
    }
    
    func minutesFrom(date:NSDate) -> Int
    {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: self, options: []).minute
    }
    
    func secondsFrom(date:NSDate) -> Int
    {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: date, toDate: self, options: []).second
    }
    
    func offsetFrom(date:NSDate) -> String
    {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
