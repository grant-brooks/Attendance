//
//  Menu-Controller.swift
//  Robotics Attendance
//
//  Created by Grant Goodman on 10/2/15.
//  Copyright © 2016 NEOTechnica Corporation. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit
import MessageUI

class MEC : UIViewController, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate
{
    let locationManager = CLLocationManager()
    
    var usernameString: String! = ""
    var passwordString: String! = ""
    var firstNameString: String! = ""
    var lastNameString: String! = ""
    var emailString: String! = ""
    var daysAgoInformationWasCurrentInteger: Int! = 0
    var timesCleanedInteger: Int! = 0
    
    var totalAttendanceInteger: Int! = 0
    var signInDate: NSDate! = NSDate()
    var currentlySignedIn: Bool! = false
    
    let nothingAddedAlert = UIAlertView()
    
    var presentToday: Bool! = false
    
    var rangeErrorCode: Int! = 0
    var passwordErrorCode: Int! = 0
    
    var sessionTimeAlert: UIAlertController!
    var cleanAlert: UIAlertController!
    var rangeAlert: UIAlertController!
    var enterPasswordAlert = UIAlertView()
    var incorrectPasswordAlert: UIAlertController!
    var passwordCouldNotBeRetrievedAlert: UIAlertController!
    
    var enterPasswordAlertTextFieldString = ""
    var enterPasswordAlertTextFieldCopy: UITextField!
    
    var waitTimer: NSTimer!
    
    var glubTimer: NSTimer!
    
    var feetFromSchool: Int! = 0
    
    var enterPasswordTextFieldString = ""
    
    @IBOutlet weak var roboFishImageView: UIImageView!
    
    @IBOutlet var robofishFeedGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var glubLabel: UILabel!
    
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var signOutButton: WCB!
    @IBOutlet weak var markPresentButton: WCB!
    @IBOutlet weak var emailPeroniButton: WCB!
    @IBOutlet weak var emailLemarButton: WCB!
    @IBOutlet weak var goToWebsiteButton: WCB!
    @IBOutlet weak var goToSchoolSiteButton: WCB!
    @IBOutlet weak var signOutAndEndSessionButton: WCB!
    
    @IBOutlet weak var firstEncloserView: UIView!
    @IBOutlet weak var secondEncloserView: UIView!
    @IBOutlet weak var thirdEncloserView: UIView!
    
    @IBOutlet weak var firstTitleView: UIView!
    @IBOutlet weak var secondTitleView: UIView!
    @IBOutlet weak var thirdTitleView: UIView!
    
    @IBOutlet weak var timeLoggedLabel: UILabel!
    @IBOutlet weak var lastAttendedLabel: UILabel!
    @IBOutlet weak var timesCleanedLabel: UILabel!
    
    @IBOutlet weak var buildButton: UIButton!
    @IBOutlet weak var ntButton: UIButton!
    
    //let buildNumber = Int(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)! + 1
    let buildNumber = Int(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)!
    var buildIdentifier: String!
    var versionNumber = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    var versionCBI: String!
    var formattedVersionNumber: String!
    var versionChoice: Int! = 0
    
    var signInSignOutInteger: Int! = 0
    
    var alreadyMarkedPresent: Bool! = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        buildIdentifier = appDelegate.buildIdentifier
        
        formattedVersionNumber = versionNumber + "." + String(buildNumber)
        
        if versionChoice == 0
        {
            buildButton.setTitle(formattedVersionNumber!, forState: UIControlState.Normal)
        }
        else if versionChoice == 1
        {
            buildButton.setTitle(buildIdentifier!, forState: UIControlState.Normal)
        }
        else if versionChoice == 2
        {
            buildButton.setTitle(versionCBI, forState: UIControlState.Normal)
        }
        else if versionChoice == 3
        {
            buildButton.setTitle(formattedVersionNumber, forState: UIControlState.Normal)
            
            self.buildButton.alpha = 0.0
            
            self.ntButton.alpha = 1.0
        }
        
        versionCBI = "R010203." + String(buildNumber)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        
        signOutAndEndSessionButton.removeConstraints(signOutAndEndSessionButton.constraints)
        signOutAndEndSessionButton.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleBottomMargin]
        signOutAndEndSessionButton.translatesAutoresizingMaskIntoConstraints = true
        
        let roboFishGif = UIImage.gifWithName("robofish")
        roboFishImageView.image = roboFishGif
        
        totalAttendanceInteger = PFUser.currentUser()!.objectForKey("totalAttendance") as! Int
        signInDate = PFUser.currentUser()!.objectForKey("signInDate") as! NSDate
        currentlySignedIn = PFUser.currentUser()!.objectForKey("currentlySignedIn") as! Bool
        
        let fullNameString = firstNameString + " " + lastNameString
        
        //        print("User Name: '\(usernameString)'.")
        //        print("Password: '\(usernameString)'.")
        //        print("Name: '\(fullNameString)'.")
        //        print("Mail Address: '\(emailString)'.")
        //        print("Information is Current As of \(daysAgoInformationWasCurrentInteger) Days Ago.")
        //        print("Times Cleaned: '\(timesCleanedInteger)'.")
        
        studentNameLabel!.text = fullNameString
        
        roundAllObjects()
        
        if currentlySignedIn == false
        {
            setButtonElementsForWhiteCircularButton(signOutButton, buttonTitle: "I'M AT ROBOTICS", buttonTarget: "updateLocation", buttonEnabled: true)
            setButtonElementsForWhiteCircularButton(markPresentButton, buttonTitle: "SIGN OUT OF APPLICATION", buttonTarget: "signOut", buttonEnabled: true)
            setButtonElementsForWhiteCircularButton(signOutAndEndSessionButton, buttonTitle: "I LEFT ROBOTICS", buttonTarget: "updateLocationForSignOut", buttonEnabled: false)
        }
        else
        {
            setButtonElementsForWhiteCircularButton(signOutButton, buttonTitle: "I'M AT ROBOTICS", buttonTarget: "updateLocation",  buttonEnabled: false)
            setButtonElementsForWhiteCircularButton(markPresentButton, buttonTitle: "SIGN OUT OF APPLICATION", buttonTarget: "signOut", buttonEnabled: false)
            setButtonElementsForWhiteCircularButton(signOutAndEndSessionButton, buttonTitle: "I LEFT ROBOTICS", buttonTarget: "updateLocationForSignOut", buttonEnabled: true)
            
            self.signOutButton.alpha = 0.0
            self.markPresentButton.alpha = 0.0
            
            var buttonFrame = self.signOutAndEndSessionButton.frame
            buttonFrame.origin.x = buttonFrame.origin.x - 174
            buttonFrame.size.width = buttonFrame.width + 174
            buttonFrame.size.height = buttonFrame.height + 54
            self.signOutAndEndSessionButton.frame = buttonFrame
        }
        
        setButtonElementsForWhiteCircularButton(emailPeroniButton, buttonTitle: "CONTACT MR. PERONI", buttonTarget: "emailPeroni", buttonEnabled: true)
        
        setButtonElementsForWhiteCircularButton(emailLemarButton, buttonTitle: "CONTACT MS. LEMAR", buttonTarget: "emailLemar", buttonEnabled: true)
        
        setButtonElementsForWhiteCircularButton(goToWebsiteButton, buttonTitle: "GO TO TEAM SITE", buttonTarget: "goToWebsite", buttonEnabled: true)
        
        setButtonElementsForWhiteCircularButton(goToSchoolSiteButton, buttonTitle: "GO TO SCHOOL SITE", buttonTarget: "goToSchoolSite", buttonEnabled: true)
        
        if timesCleanedInteger == 0
        {
            timesCleanedLabel!.text = "never"
        }
        else if timesCleanedInteger == 1
        {
            timesCleanedLabel!.text = String(timesCleanedInteger) + " time"
        }
        else
        {
            timesCleanedLabel!.text = String(timesCleanedInteger) + " times"
        }
        
        updateLastAttendanceLabel()
    }
    
    @IBAction func buildButton(sender: AnyObject)
    {
        if buildButton.titleLabel!.text == formattedVersionNumber
        {
            buildButton.setTitle(buildIdentifier, forState: UIControlState.Normal)
            versionChoice = 1
        }
        else if buildButton.titleLabel!.text == buildIdentifier
        {
            buildButton.setTitle(versionCBI, forState: UIControlState.Normal)
            versionChoice = 2
        }
        else if buildButton.titleLabel!.text == versionCBI
        {
            buildButton.setTitle(formattedVersionNumber, forState: UIControlState.Normal)
            
            versionChoice = 3
            
            self.buildButton.alpha = 0.0
            
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    self.ntButton.alpha = 1.0
                    
                }, completion:
                {
                    finished in
                    if finished
                    {
                    }
            })
        }
    }
    
    @IBAction func ntButton(sender: AnyObject)
    {
        self.ntButton.alpha = 0.0
        
        versionChoice = 0
        
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
                self.buildButton.alpha = 1.0
                
            }, completion:
            {
                finished in
                if finished
                {
                }
        })
    }
    
    @IBAction func longPress(sender: AnyObject)
    {
        let pasteBoard = UIPasteboard.generalPasteboard()
        pasteBoard.string = buildButton.titleLabel!.text
    }
    
    @IBAction func robofishFeedGesture(sender: AnyObject)
    {
        glubLabel.hidden = false
        glubTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "stopFeeding", userInfo: nil, repeats: false)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            self.feetFromSchool = 0
            
            if (error != nil) {
                print("Reverse geocoder failed with error: '" + error!.localizedDescription + "'.")
                self.rangeErrorCode = 3
                PKHUD.sharedHUD.hide(afterDelay: 0.0)
                self.waitTimer.invalidate()
                NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "markPresent", userInfo: nil, repeats: false)
                return
            }
            
            if placemarks!.count > 0
            {
                let schoolLocation = CLLocation(latitude: 40.838335, longitude: -73.631335)
                let metersFromSchool = locations[0].distanceFromLocation(schoolLocation)
                
                self.feetFromSchool = Int(metersFromSchool * 3.280839895)
                
                if self.feetFromSchool > 500
                {
                    if self.feetFromSchool > 1000
                    {
                        self.rangeErrorCode = 4
                    }
                    else
                    {
                        self.rangeErrorCode = 2
                    }
                    
                    print("This user is not within ample range of the school. \n(\(self.feetFromSchool) ft.)")
                    PKHUD.sharedHUD.hide(afterDelay: 0.0)
                    self.waitTimer.invalidate()
                    if self.signInSignOutInteger == 1
                    {
                        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "markPresent", userInfo: nil, repeats: false)
                    }
                    else if self.signInSignOutInteger == 2
                    {
                        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "endSession", userInfo: nil, repeats: false)
                    }
                }
                else
                {
                    print("This user is within ample range of the school. \n(\(self.feetFromSchool) ft.)")
                    self.rangeErrorCode = 1
                    PKHUD.sharedHUD.hide(afterDelay: 0.0)
                    self.waitTimer.invalidate()
                    if self.signInSignOutInteger == 1
                    {
                        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "markPresent", userInfo: nil, repeats: false)
                    }
                    else if self.signInSignOutInteger == 2
                    {
                        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "endSession", userInfo: nil, repeats: false)
                    }
                    self.alreadyMarkedPresent = true
                }
                
                self.locationManager.stopUpdatingLocation()
            }
            else
            {
                print("There was a problem with the data received from geocoder.")
                self.rangeErrorCode = 3
                PKHUD.sharedHUD.hide(afterDelay: 0.0)
                self.waitTimer.invalidate()
                NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "markPresent", userInfo: nil, repeats: false)
            }
        })
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        //print("The location failed to update with error: '" + error.localizedDescription + "'.")
        PKHUD.sharedHUD.hide(afterDelay: 0.0)
        self.waitTimer.invalidate()
        
        if signInSignOutInteger == 1
        {
            rangeErrorCode = 3
            markPresent()
        }
        else if signInSignOutInteger == 2
        {
            rangeErrorCode = 3
            endSession()
        }
    }
    
    func signOut()
    {
        performSegueWithIdentifier("backToLoginSegueFromAttendance", sender: self)
    }
    
    func stopFeeding()
    {
        glubLabel.hidden = true
        glubTimer.invalidate()
    }
    
    func updateLastAttendanceLabel()
    {
        let unformattedTimeLogged = PFUser.currentUser()?.valueForKey("totalTimeLogged") as! Double
        let timeLoggedInDays = Int(unformattedTimeLogged / 86400)
        let timeLoggedInDaysDouble: Double! = Double(unformattedTimeLogged / 86400 - Double(timeLoggedInDays))
        let timeLoggedInHours = Int(timeLoggedInDaysDouble * 24)
        let timeLoggedInMinutesFromHours = timeLoggedInDaysDouble * 24 - Double(timeLoggedInHours)
        let timeLoggedInMinutes = Int(timeLoggedInMinutesFromHours * 60)
        let timeLoggedInSecondsFromMinutes = timeLoggedInMinutesFromHours * 60 - Double(timeLoggedInMinutes)
        let timeLoggedInSeconds = Int(timeLoggedInSecondsFromMinutes * 60)
        
        if timeLoggedInDays == 0
        {
            if timeLoggedInHours == 0
            {
                if timeLoggedInMinutes == 0
                {
                    if timeLoggedInSeconds == 0
                    {
                        timeLoggedLabel.text = "none"
                    }
                    else
                    {
                        timeLoggedLabel.text = String(timeLoggedInSeconds) + "s"
                    }
                }
                else
                {
                    if timeLoggedInSeconds == 0
                    {
                        timeLoggedLabel.text = String(timeLoggedInMinutes) + "m"
                    }
                    else
                    {
                        timeLoggedLabel.text = String(timeLoggedInMinutes) + "m " + String(timeLoggedInSeconds) + "s"
                    }
                }
            }
            else
            {
                if timeLoggedInMinutes == 0
                {
                    timeLoggedLabel.text = String(timeLoggedInHours) + "h"
                }
                else
                {
                    timeLoggedLabel.text = String(timeLoggedInHours) + "h " + String(timeLoggedInMinutes) + "m"
                }
            }
        }
        else
        {
            if timeLoggedInDays == 0
            {
                if timeLoggedInMinutes == 0
                {
                    timeLoggedLabel.text = String(timeLoggedInHours) + "h"
                }
                else
                {
                    timeLoggedLabel.text = String(timeLoggedInHours) + "h " + String(timeLoggedInMinutes) + "m"
                }
            }
            else
            {
                if timeLoggedInHours == 0
                {
                    timeLoggedLabel.text = String(timeLoggedInDays) + "d"
                }
                else
                {
                    if timeLoggedInMinutes == 0
                    {
                        timeLoggedLabel.text = String(timeLoggedInDays) + "d " + String(timeLoggedInHours) + "h"
                    }
                    else
                    {
                        timeLoggedLabel.text = String(timeLoggedInDays) + "d " + String(timeLoggedInHours) + "h " + String(timeLoggedInMinutes) + "m"
                    }
                }
            }
        }
        
        //Declare 'updatedAtFormatter' as an NSDateFormatter.
        let updatedAtFormatter = NSDateFormatter()
        
        //Set the dateFormat of the updatedDateFormatter.
        updatedAtFormatter.dateFormat = "yyyy-MM-dd"
        
        //Declare 'updatedAtString' as the string value of the date and/or that time the person last signed out.
        let updatedAtString = updatedAtFormatter.stringFromDate(PFUser.currentUser()?.valueForKey("signOutDate") as! NSDate)
        
        //Declare 'currentDate' as the current date as an NSDate.
        let currentDate = NSDate()
        
        //Declare 'currentDateString' as the string value of the current date.
        let currentDateString = updatedAtFormatter.stringFromDate(currentDate)
        
        //Declare 'dateFormatter' as an NSDateFormatter.
        let dateFormatter = NSDateFormatter()
        
        //Set the dateFormat of the dateFormatter.
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //Declare 'startDate' as the result of a formatting of the current date as an NSDate.
        let startDate: NSDate = dateFormatter.dateFromString(currentDateString)!
        
        //Declare 'endDate' as the result of a formatting of the date and/or that time the person last signed out.
        let endDate: NSDate = dateFormatter.dateFromString(updatedAtString)!
        
        //Declare 'currentCalendar' as the current calendar.
        let currentCalendar = NSCalendar.currentCalendar()
        
        //Declare 'calendarUnit' as the day as an NSCalendarUnit.
        let calendarUnit: NSCalendarUnit = NSCalendarUnit.Day
        
        //Declare 'calendarComponents' as various components of currentCalendar.
        let calendarComponents = currentCalendar.components(calendarUnit, fromDate: startDate, toDate: endDate, options: [])
        
        //If the person last signed out today, perform various actions.
        if calendarComponents.day == 0
        {
            //            presentToday = true
            
            //            markPresentButton.layer.borderColor = UIColor.grayColor().CGColor
            //            markPresentButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            //            markPresentButton.enabled = false
            //            markPresentButton.userInteractionEnabled = false
            
            //Declare 'timeFormatter' as an NSDateFormatter.
            let timeFormatter = NSDateFormatter()
            
            //Set the dateFormat of the timeFormatter.
            timeFormatter.dateFormat = "hh:mm a"
            
            //Declare 'updatedAtString' as the string value of the date and/or that time the person last signed out.
            var updatedAtString = timeFormatter.stringFromDate(PFUser.currentUser()?.valueForKey("signOutDate") as! NSDate)
            
            //If the updatedAtString has a prefix of '0', perform various actions.
            //Otherwise, perform various actions.
            if updatedAtString.hasPrefix("0")
            {
                //Drop the first character of the updatedAtString.
                updatedAtString = String(updatedAtString.characters.dropFirst())
                
                lastAttendedLabel.text = "Today at " + updatedAtString
            }
            else
            {
                lastAttendedLabel.text = "Today at " + updatedAtString
            }
        }
        else if calendarComponents.day == -1
        {
            lastAttendedLabel.text = "Yesterday"
        }
        else if calendarComponents.day <= -2 && calendarComponents.day > -7
        {
            lastAttendedLabel.text = String(calendarComponents.day).stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil) + " days ago"
        }
        else if calendarComponents.day <= -7 && calendarComponents.day > -28
        {
            //Declare 'amountOfWeeksSincePersonLastSignedOutInteger' as an integer being the amount of days since the current person last signed out divided by seven, effectively getting a value in weeks.
            let amountOfWeeksSincePersonLastSignedOutInteger = calendarComponents.day / 7
            
            lastAttendedLabel.text = String(amountOfWeeksSincePersonLastSignedOutInteger).stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil) + " weeks ago"
        }
        else if calendarComponents.day <= -28 && calendarComponents.day > -365
        {
            //Declare 'monthDayFormatter' as an NSDateFormatter.
            let monthDayFormatter = NSDateFormatter()
            
            //Set the dateFormat of the monthDayFormatter.
            monthDayFormatter.dateFormat = "MMMM dd"
            
            //Declare 'updatedAtString' as the string value of the date and/or that time the person last signed out.
            let updatedAtString = monthDayFormatter.stringFromDate(PFUser.currentUser()?.valueForKey("signOutDate") as! NSDate)
            
            lastAttendedLabel.text = updatedAtString + daySuffix(PFUser.currentUser()?.valueForKey("signOutDate") as! NSDate)
        }
        else if calendarComponents.day <= -365 && calendarComponents.day > -1285
        {
            //Declare 'amountOfYearsSincePersonLastSignedOutInteger' as an integer being the amount of days since the current person last signed out divided by three hundred sixty-five, effectively getting a value in years.
            let amountOfYearsSincePersonLastSignedOutInteger = calendarComponents.day / 365
            
            lastAttendedLabel.text = String(amountOfYearsSincePersonLastSignedOutInteger).stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil) + " years ago"
        }
        else if calendarComponents.day <= -1285
        {
            //Declare 'updatedAtFormatter' as an NSDateFormatter.
            let updatedAtFormatter = NSDateFormatter()
            
            //Set the dateFormat of the updatedAtFormatter.
            updatedAtFormatter.dateFormat = "MMMM dd, yyyy"
            
            //Declare 'updatedAtString' as the string value of the date and/or that time the person last signed out.
            let updatedAtString = updatedAtFormatter.stringFromDate(PFUser.currentUser()?.valueForKey("signOutDate") as! NSDate)
            
            lastAttendedLabel.text = updatedAtString
        }
        else
        {
            //Declare 'updatedAtFormatter' as an NSDateFormatter.
            let updatedAtFormatter = NSDateFormatter()
            
            //Set the dateFormat of the updatedAtFormatter.
            updatedAtFormatter.dateFormat = "MMMM dd, yyyy"
            
            //Declare 'updatedAtString' as the string value of the date and/or that time the person last signed out.
            let updatedAtString = updatedAtFormatter.stringFromDate(PFUser.currentUser()?.valueForKey("signOutDate") as! NSDate)
            
            lastAttendedLabel.text = updatedAtString
        }
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
        circularButton.setTitle(buttonTitle.uppercaseString, forState: UIControlState.Normal)
        
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
        circularButton.setTitle(buttonTitle.uppercaseString, forState: UIControlState.Normal)
        
        if buttonTarget != nil
        {
            let buttonTargetSelector: Selector = NSSelectorFromString(buttonTarget!)
            circularButton.addTarget(self, action: buttonTargetSelector, forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func goToWebsite()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.team3950.com")!)
    }
    
    func goToSchoolSite()
    {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://northshoreschools.org")!)
    }
    
    func emailPeroni()
    {
        sendEmailToAddress("peronis@northshoreschools.org")
    }
    
    func emailLemar()
    {
        sendEmailToAddress("lemars@northshoreschools.org")
    }
    
    func updateLocation()
    {
        locationManager.startUpdatingLocation()
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        
        PKHUD.sharedHUD.hide(afterDelay: 25.0)
        waitTimer = NSTimer.scheduledTimerWithTimeInterval(26.0, target: self, selector: "afterWaitShowError", userInfo: nil, repeats: false)
        signInSignOutInteger = 1
    }
    
    func updateLocationForSignOut()
    {
        locationManager.startUpdatingLocation()
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        
        PKHUD.sharedHUD.hide(afterDelay: 25.0)
        waitTimer = NSTimer.scheduledTimerWithTimeInterval(26.0, target: self, selector: "afterWaitShowError", userInfo: nil, repeats: false)
        signInSignOutInteger = 2
    }
    
    func afterWaitShowError()
    {
        if signInSignOutInteger == 1
        {
            rangeErrorCode = 3
            markPresent()
        }
        else if signInSignOutInteger == 2
        {
            rangeErrorCode = 3
            endSession()
        }
    }
    
    func markPresent()
    {
        if rangeErrorCode == 1
        {
            setButtonElementsForWhiteCircularButton(signOutAndEndSessionButton, buttonTitle: "I LEFT ROBOTICS", buttonTarget: "updateLocationForSignOut", buttonEnabled: true)
            
            PFUser.currentUser()!.setObject(NSDate(), forKey: "signInDate")
            PFUser.currentUser()!.setObject(PFUser.currentUser()!.objectForKey("totalAttendance") as! Int + 1, forKey: "totalAttendance")
            PFUser.currentUser()!.setObject(true, forKey: "currentlySignedIn")
            
            PFUser.currentUser()!.saveInBackgroundWithBlock
                {
                    (savedSuccessfully: Bool, occurredError: NSError?) -> Void in
                    
                    if savedSuccessfully
                    {
                        print("The object was saved successfully.")
                        
                        if self.signOutButton.alpha != 0.0
                        {
                            UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                                
                                self.signOutButton.alpha = 0.0
                                self.markPresentButton.alpha = 0.0
                                
                                var buttonFrame = self.signOutAndEndSessionButton.frame
                                buttonFrame.origin.x = buttonFrame.origin.x - 174
                                buttonFrame.size.width = buttonFrame.width + 174
                                buttonFrame.size.height = buttonFrame.height + 54
                                self.signOutAndEndSessionButton.frame = buttonFrame
                                
                                }, completion: {finished in
                                    
                                    if finished {
                                        
                                        self.markPresentButton.layer.borderColor = UIColor.grayColor().CGColor
                                        self.markPresentButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                                        self.markPresentButton.enabled = false
                                        self.markPresentButton.userInteractionEnabled = false
                                        
                                        self.signOutButton.layer.borderColor = UIColor.grayColor().CGColor
                                        self.signOutButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                                        self.signOutButton.enabled = false
                                        self.signOutButton.userInteractionEnabled = false
                                        
                                    }})
                        }
                    }
                        
                    else
                    {
                        print("An error occurred while saving data the query.")
                        print("Technical Information: '\(occurredError)'.")
                    }
            }
        }
        else
        {
            if rangeErrorCode == 2
            {
                self.locationManager.stopUpdatingLocation()
                self.rangeAlert = UIAlertController(title: "Too Far From School", message: "You are not within ample range of the school to mark yourself present at robotics.\n\nYour location from school: \(feetFromSchool) ft.", preferredStyle: UIAlertControllerStyle.Alert)
                
                rangeAlert.addAction(UIAlertAction(title: "Override", style: .Default, handler: { (action: UIAlertAction!) in
                    self.displayEnterPasswordAlert()
                }))
                
                rangeAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                
                presentViewController(rangeAlert, animated: true, completion: nil)
                self.locationManager.stopUpdatingLocation()
            }
            else if rangeErrorCode == 3
            {
                self.locationManager.stopUpdatingLocation()
                self.rangeAlert = UIAlertController(title: "Location Could Not Be Determined", message: "Your distance from the school could not be determined.\n\nYou will not be able to mark yourself present at robotics.", preferredStyle: UIAlertControllerStyle.Alert)
                
                rangeAlert.addAction(UIAlertAction(title: "Override", style: .Default, handler: { (action: UIAlertAction!) in
                    self.displayEnterPasswordAlert()
                }))
                
                rangeAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                
                presentViewController(rangeAlert, animated: true, completion: nil)
                self.locationManager.stopUpdatingLocation()
            }
            else if rangeErrorCode == 4
            {
                self.locationManager.stopUpdatingLocation()
                self.rangeAlert = UIAlertController(title: "Too Far From School", message: "You are not within ample range of the school to mark yourself present at robotics.", preferredStyle: UIAlertControllerStyle.Alert)
                
                rangeAlert.addAction(UIAlertAction(title: "Override", style: .Default, handler: { (action: UIAlertAction!) in
                    self.displayEnterPasswordAlert()
                }))
                
                rangeAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                
                presentViewController(rangeAlert, animated: true, completion: nil)
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func displayEnterPasswordAlert()
    {
        enterPasswordAlert.title = "Override Location Detection"
        enterPasswordAlert.message = "Enter administrator password."
        enterPasswordAlert.delegate = self
        enterPasswordAlert.tag = 100
        
        let enterPasswordAlertTextField = enterPasswordAlert.textFieldAtIndex(0)
        enterPasswordAlertTextField?.secureTextEntry = true
        enterPasswordAlertTextField?.placeholder = "Required"
        enterPasswordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        
        enterPasswordAlert.addButtonWithTitle("Confirm")
        enterPasswordAlert.addButtonWithTitle("Cancel")
        enterPasswordAlert.cancelButtonIndex = 0
        enterPasswordAlertTextFieldCopy = enterPasswordAlertTextField
        enterPasswordAlertTextFieldCopy?.secureTextEntry = true
        enterPasswordAlert.show()
    }
    
    func displayEnterPasswordAlertForSignOut()
    {
        enterPasswordAlert.title = "Override Location Detection"
        enterPasswordAlert.message = "Enter administrator password."
        enterPasswordAlert.delegate = self
        enterPasswordAlert.tag = 200
        
        let enterPasswordAlertTextField = enterPasswordAlert.textFieldAtIndex(0)
        enterPasswordAlertTextField?.secureTextEntry = true
        enterPasswordAlertTextField?.placeholder = "Required"
        enterPasswordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        
        enterPasswordAlert.addButtonWithTitle("Confirm")
        enterPasswordAlert.addButtonWithTitle("Cancel")
        enterPasswordAlert.cancelButtonIndex = 0
        enterPasswordAlertTextFieldCopy = enterPasswordAlertTextField
        enterPasswordAlertTextFieldCopy?.secureTextEntry = true
        enterPasswordAlert.show()
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 1:
            break;
        case 0:
            if View.tag == 100
            {
                enterPasswordAlertTextFieldCopy = enterPasswordAlert.textFieldAtIndex(0)
                enterPasswordTextFieldString = enterPasswordAlertTextFieldCopy.text!
                
                if enterPasswordTextFieldString != ""
                {
                    if enterPasswordTextFieldString == "def11545ab"
                    {
                        rangeErrorCode = 1
                        markPresent()
                    }
                    else
                    {
                        self.incorrectPasswordAlert = UIAlertController(title: "Incorrect Password", message: "The password that you entered was incorrect.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        incorrectPasswordAlert.addAction(UIAlertAction(title: "Try Again", style: .Cancel, handler: { (action: UIAlertAction!) in
                            self.displayEnterPasswordAlert()
                        }))
                        
                        incorrectPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        presentViewController(incorrectPasswordAlert, animated: true, completion: nil)
                    }
                }
                else
                {
                    nothingAddedAlert.title = "Nothing Added"
                    nothingAddedAlert.message = "You did not enter anything."
                    
                    _ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("dismissNothingAddedAlert"), userInfo: nil, repeats: true)
                    
                    nothingAddedAlert.show()
                }
            }
            else if View.tag == 200
            {
                enterPasswordAlertTextFieldCopy = enterPasswordAlert.textFieldAtIndex(0)
                enterPasswordTextFieldString = enterPasswordAlertTextFieldCopy.text!
                
                if enterPasswordTextFieldString != ""
                {
                    if enterPasswordTextFieldString == "def11545ab"
                    {
                        rangeErrorCode = 1
                        endSession()
                    }
                    else
                    {
                        self.incorrectPasswordAlert = UIAlertController(title: "Incorrect Password", message: "The password that you entered was incorrect.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        incorrectPasswordAlert.addAction(UIAlertAction(title: "Try Again", style: .Cancel, handler: { (action: UIAlertAction!) in
                            self.displayEnterPasswordAlert()
                        }))
                        
                        incorrectPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        presentViewController(incorrectPasswordAlert, animated: true, completion: nil)
                    }
                }
                else
                {
                    nothingAddedAlert.title = "Nothing Added"
                    nothingAddedAlert.message = "You did not enter anything."
                    
                    _ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("dismissNothingAddedAlert"), userInfo: nil, repeats: true)
                    
                    nothingAddedAlert.show()
                }
            }
            break;
        default:
            break;
        }
    }
    
    func dismissNothingAddedAlert()
    {
        nothingAddedAlert.dismissWithClickedButtonIndex(0, animated: true)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("displayEnterPasswordAlert"), userInfo: nil, repeats: true)
    }
    
    
    func endSession()
    {
        if rangeErrorCode == 1
        {
            self.cleanAlert = UIAlertController(title: "Did you clean today?", message: "Be honest.\n\nWe're watching you.", preferredStyle: UIAlertControllerStyle.Alert)
            
            cleanAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
                self.presentViewController(self.sessionTimeAlert, animated: true, completion: nil)
            }))
            
            cleanAlert.addAction(UIAlertAction(title: "Yes", style: .Cancel, handler: { (action: UIAlertAction!) in
                
                PFUser.currentUser()?.setValue(self.timesCleanedInteger + 1, forKey: "timesCleaned")
                PFUser.currentUser()!.saveInBackgroundWithBlock
                    {
                        (savedSuccessfully: Bool, occurredError: NSError?) -> Void in
                        
                        if savedSuccessfully
                        {
                            print("The object was saved successfully.")
                            
                            if self.timesCleanedLabel.text == "never"
                            {
                                self.timesCleanedLabel.text = String(self.timesCleanedInteger + 1) + " time"
                            }
                            else
                            {
                                self.timesCleanedLabel.text = String(self.timesCleanedInteger + 1) + " times"
                            }
                            
                            self.presentViewController(self.sessionTimeAlert, animated: true, completion: nil)
                        }
                            
                        else
                        {
                            print("An error occurred while saving data the query.")
                            print("Technical Information: '\(occurredError)'.")
                        }
                }
                
            }))
            
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
            signOutDate = currentDateAndTime
            
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
                
                self.updateLastAttendanceLabel()
                
                PFUser.currentUser()!.setObject(false, forKey: "currentlySignedIn")
                
                PFUser.currentUser()!.saveInBackgroundWithBlock
                    {
                        (savedSuccessfully: Bool, occurredError: NSError?) -> Void in
                        
                        if savedSuccessfully
                        {
                            print("The object was saved successfully.")
                            //                            PFUser.logOut()
                        }
                            
                        else
                        {
                            print("An error occurred while saving data the query.")
                            print("Technical Information: '\(occurredError)'.")
                        }
                }
                
                self.presentToday = true
                self.signOutButton.layer.borderColor = UIColor.grayColor().CGColor
                self.signOutButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                self.signOutButton.enabled = false
                self.signOutButton.userInteractionEnabled = false
                
                UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    
                    self.signOutButton.alpha = 0.0
                    self.markPresentButton.alpha = 0.0
                    
                    }, completion: {finished in
                        
                        if finished {
                            
                            UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                                
                                self.signOutButton.alpha = 1.0
                                self.markPresentButton.alpha = 1.0
                                
                                self.signOutAndEndSessionButton.layer.borderColor = UIColor.whiteColor().CGColor
                                self.signOutAndEndSessionButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                                self.signOutAndEndSessionButton.enabled = true
                                self.signOutAndEndSessionButton.userInteractionEnabled = true
                                
                                var buttonFrame = self.signOutAndEndSessionButton.frame
                                buttonFrame.origin.x = buttonFrame.origin.x + 174
                                buttonFrame.size.width = buttonFrame.width - 174
                                buttonFrame.size.height = buttonFrame.height - 54
                                self.signOutAndEndSessionButton.frame = buttonFrame
                                
                                }, completion: {finished in
                                    
                                    self.signOutButton.layer.borderColor = UIColor.whiteColor().CGColor
                                    self.signOutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                                    self.signOutButton.enabled = true
                                    self.signOutButton.userInteractionEnabled = true
                                    
                                    self.markPresentButton.layer.borderColor = UIColor.whiteColor().CGColor
                                    self.markPresentButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                                    self.markPresentButton.enabled = true
                                    self.markPresentButton.userInteractionEnabled = true
                                    
                                    
                                    self.signOutAndEndSessionButton.layer.borderColor = UIColor.grayColor().CGColor
                                    self.signOutAndEndSessionButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                                    self.signOutAndEndSessionButton.enabled = false
                                    self.signOutAndEndSessionButton.userInteractionEnabled = false
                            })
                        }})
            }))
            
            presentViewController(cleanAlert, animated: true, completion: nil)
        }
        else
        {
            if rangeErrorCode == 2
            {
                self.rangeAlert = UIAlertController(title: "Too Far From School", message: "Your location since marking yourself present at robotics has changed to a distance that is too far from the school.\n\nThe hours you have logged since marking yourself present for the current session will not be recorded.", preferredStyle: UIAlertControllerStyle.Alert)
                
                rangeAlert.addAction(UIAlertAction(title: "Override", style: .Default, handler: { (action: UIAlertAction!) in
                    self.displayEnterPasswordAlertForSignOut()
                }))
                
                rangeAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
                    UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        
                        self.signOutButton.alpha = 1.0
                        self.markPresentButton.alpha = 1.0
                        
                        self.signOutAndEndSessionButton.layer.borderColor = UIColor.whiteColor().CGColor
                        self.signOutAndEndSessionButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                        self.signOutAndEndSessionButton.enabled = true
                        self.signOutAndEndSessionButton.userInteractionEnabled = true
                        
                        var buttonFrame = self.signOutAndEndSessionButton.frame
                        buttonFrame.origin.x = buttonFrame.origin.x + 174
                        buttonFrame.size.width = buttonFrame.width - 174
                        buttonFrame.size.height = buttonFrame.height - 54
                        self.signOutAndEndSessionButton.frame = buttonFrame
                        
                        }, completion: {finished in
                            
                            self.signOutButton.layer.borderColor = UIColor.whiteColor().CGColor
                            self.signOutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                            self.signOutButton.enabled = true
                            self.signOutButton.userInteractionEnabled = true
                            
                            self.markPresentButton.layer.borderColor = UIColor.whiteColor().CGColor
                            self.markPresentButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                            self.markPresentButton.enabled = true
                            self.markPresentButton.userInteractionEnabled = true
                            
                            
                            self.signOutAndEndSessionButton.layer.borderColor = UIColor.grayColor().CGColor
                            self.signOutAndEndSessionButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                            self.signOutAndEndSessionButton.enabled = false
                            self.signOutAndEndSessionButton.userInteractionEnabled = false
                    })
                }))
                
                presentViewController(rangeAlert, animated: true, completion: nil)
            }
            else if rangeErrorCode == 3
            {
                self.rangeAlert = UIAlertController(title: "Location Could Not Be Determined", message: "Your distance from the school could not be determined.\n\nTherefore, whether or not you left ample proximity of the school cannot be accurately determined.\n\nThe hours you have logged since marking yourself present for the current session will not be recorded.", preferredStyle: UIAlertControllerStyle.Alert)
                
                rangeAlert.addAction(UIAlertAction(title: "Override", style: .Default, handler: { (action: UIAlertAction!) in
                    self.displayEnterPasswordAlertForSignOut()
                }))
                
                rangeAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
                    UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        
                        self.signOutButton.alpha = 1.0
                        self.markPresentButton.alpha = 1.0
                        
                        self.signOutAndEndSessionButton.layer.borderColor = UIColor.whiteColor().CGColor
                        self.signOutAndEndSessionButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                        self.signOutAndEndSessionButton.enabled = true
                        self.signOutAndEndSessionButton.userInteractionEnabled = true
                        
                        var buttonFrame = self.signOutAndEndSessionButton.frame
                        buttonFrame.origin.x = buttonFrame.origin.x + 174
                        buttonFrame.size.width = buttonFrame.width - 174
                        buttonFrame.size.height = buttonFrame.height - 54
                        self.signOutAndEndSessionButton.frame = buttonFrame
                        
                        }, completion: {finished in
                            
                            self.signOutButton.layer.borderColor = UIColor.whiteColor().CGColor
                            self.signOutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                            self.signOutButton.enabled = true
                            self.signOutButton.userInteractionEnabled = true
                            
                            self.markPresentButton.layer.borderColor = UIColor.whiteColor().CGColor
                            self.markPresentButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                            self.markPresentButton.enabled = true
                            self.markPresentButton.userInteractionEnabled = true
                            
                            
                            self.signOutAndEndSessionButton.layer.borderColor = UIColor.grayColor().CGColor
                            self.signOutAndEndSessionButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                            self.signOutAndEndSessionButton.enabled = false
                            self.signOutAndEndSessionButton.userInteractionEnabled = false
                    })
                }))
                
                presentViewController(rangeAlert, animated: true, completion: nil)
            }
            else if rangeErrorCode == 4
            {
                self.rangeAlert = UIAlertController(title: "Too Far From School", message: "Your location since marking yourself present at robotics has changed to a distance that is too far from the school.\n\nThe hours you have logged since marking yourself present for the current session will not be recorded.", preferredStyle: UIAlertControllerStyle.Alert)
                
                rangeAlert.addAction(UIAlertAction(title: "Override", style: .Default, handler: { (action: UIAlertAction!) in
                    self.displayEnterPasswordAlertForSignOut()
                }))
                
                rangeAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) in
                    UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        
                        self.signOutButton.alpha = 1.0
                        self.markPresentButton.alpha = 1.0
                        
                        self.signOutAndEndSessionButton.layer.borderColor = UIColor.whiteColor().CGColor
                        self.signOutAndEndSessionButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                        self.signOutAndEndSessionButton.enabled = true
                        self.signOutAndEndSessionButton.userInteractionEnabled = true
                        
                        var buttonFrame = self.signOutAndEndSessionButton.frame
                        buttonFrame.origin.x = buttonFrame.origin.x + 174
                        buttonFrame.size.width = buttonFrame.width - 174
                        buttonFrame.size.height = buttonFrame.height - 54
                        self.signOutAndEndSessionButton.frame = buttonFrame
                        
                        }, completion: {finished in
                            
                            self.signOutButton.layer.borderColor = UIColor.whiteColor().CGColor
                            self.signOutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                            self.signOutButton.enabled = true
                            self.signOutButton.userInteractionEnabled = true
                            
                            self.markPresentButton.layer.borderColor = UIColor.whiteColor().CGColor
                            self.markPresentButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                            self.markPresentButton.enabled = true
                            self.markPresentButton.userInteractionEnabled = true
                            
                            
                            self.signOutAndEndSessionButton.layer.borderColor = UIColor.grayColor().CGColor
                            self.signOutAndEndSessionButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                            self.signOutAndEndSessionButton.enabled = false
                            self.signOutAndEndSessionButton.userInteractionEnabled = false
                    })
                }))
                
                presentViewController(rangeAlert, animated: true, completion: nil)
            }
        }
    }
    
    func sendEmailToAddress(mailAddress: String!)
    {
        let mailComposeViewController = configuredMailComposeViewControllerWithAddress(mailAddress)
        
        if MFMailComposeViewController.canSendMail()
        {
            presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
        else
        {
            showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewControllerWithAddress(mailAddress: String!) -> MFMailComposeViewController
    {
        let mailComposerViewController = MFMailComposeViewController()
        mailComposerViewController.mailComposeDelegate = self
        
        mailComposerViewController.setToRecipients([mailAddress])
        
        return mailComposerViewController
    }
    
    func showSendMailErrorAlert()
    {
        let sendMailErrorAlert = UIAlertController(title: "Cannot Send Mail", message: "This device is not capable of sending mail.\nPlease configure your mailing client and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        
        sendMailErrorAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        
        presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func roundAllObjects()
    {
        let maskPathForFirstEncloserView: UIBezierPath = UIBezierPath(roundedRect: firstEncloserView!.bounds,
            byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.BottomLeft, UIRectCorner.TopRight, UIRectCorner.BottomRight],
            cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayerForFirstEncloserView: CAShapeLayer = CAShapeLayer()
        
        maskLayerForFirstEncloserView.frame = firstEncloserView!.bounds
        maskLayerForFirstEncloserView.path = maskPathForFirstEncloserView.CGPath
        
        firstEncloserView!.layer.mask = maskLayerForFirstEncloserView
        firstEncloserView!.layer.masksToBounds = false
        firstEncloserView!.clipsToBounds = true
        
        
        let maskPathForSecondEncloserView: UIBezierPath = UIBezierPath(roundedRect: secondEncloserView!.bounds,
            byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.BottomLeft, UIRectCorner.TopRight, UIRectCorner.BottomRight],
            cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayerForSecondEncloserView: CAShapeLayer = CAShapeLayer()
        
        maskLayerForSecondEncloserView.frame = secondEncloserView!.bounds
        maskLayerForSecondEncloserView.path = maskPathForSecondEncloserView.CGPath
        
        secondEncloserView!.layer.mask = maskLayerForSecondEncloserView
        secondEncloserView!.layer.masksToBounds = false
        secondEncloserView!.clipsToBounds = true
        
        
        let maskPathForFirstTitleView: UIBezierPath = UIBezierPath(roundedRect: firstTitleView!.bounds,
            byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.BottomLeft, UIRectCorner.TopRight, UIRectCorner.BottomRight],
            cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayerForFirstTitleView: CAShapeLayer = CAShapeLayer()
        
        maskLayerForFirstTitleView.frame = firstTitleView!.bounds
        maskLayerForFirstTitleView.path = maskPathForFirstTitleView.CGPath
        
        firstTitleView!.layer.mask = maskLayerForFirstTitleView
        firstTitleView!.layer.masksToBounds = false
        firstTitleView!.clipsToBounds = true
        
        
        let maskPathForSecondTitleView: UIBezierPath = UIBezierPath(roundedRect: secondTitleView!.bounds,
            byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.BottomLeft, UIRectCorner.TopRight, UIRectCorner.BottomRight],
            cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayerForSecondTitleView: CAShapeLayer = CAShapeLayer()
        
        maskLayerForSecondTitleView.frame = secondTitleView!.bounds
        maskLayerForSecondTitleView.path = maskPathForSecondTitleView.CGPath
        
        secondTitleView!.layer.mask = maskLayerForSecondTitleView
        secondTitleView!.layer.masksToBounds = false
        secondTitleView!.clipsToBounds = true
        
        
        let maskPathForThirdTitleView: UIBezierPath = UIBezierPath(roundedRect: thirdTitleView!.bounds,
            byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.BottomLeft, UIRectCorner.TopRight, UIRectCorner.BottomRight],
            cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayerForThirdTitleView: CAShapeLayer = CAShapeLayer()
        
        maskLayerForThirdTitleView.frame = thirdTitleView!.bounds
        maskLayerForThirdTitleView.path = maskPathForThirdTitleView.CGPath
        
        thirdTitleView!.layer.mask = maskLayerForThirdTitleView
        thirdTitleView!.layer.masksToBounds = false
        thirdTitleView!.clipsToBounds = true
        
        
        let maskPathForThirdEncloserView: UIBezierPath = UIBezierPath(roundedRect: thirdEncloserView!.bounds,
            byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.BottomLeft, UIRectCorner.TopRight, UIRectCorner.BottomRight],
            cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayerForThirdEncloserView: CAShapeLayer = CAShapeLayer()
        
        maskLayerForThirdEncloserView.frame = thirdEncloserView!.bounds
        maskLayerForThirdEncloserView.path = maskPathForThirdEncloserView.CGPath
        
        thirdEncloserView!.layer.mask = maskLayerForThirdEncloserView
        thirdEncloserView!.layer.masksToBounds = false
        thirdEncloserView!.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func attendanceButton(sender: AnyObject)
    {
        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.firstEncloserView.alpha = 0.0
            self.firstTitleView.alpha = 0.0
            
            self.secondEncloserView.alpha = 0.0
            self.secondTitleView.alpha = 0.0
            
            self.thirdEncloserView.alpha = 0.0
            self.thirdTitleView.alpha = 0.0
            
            self.studentNameLabel.alpha = 0.0
            
            }, completion: {finished in
                
                if finished {self.performSegueWithIdentifier("attendanceSegueFromMenu", sender: self)}})
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "attendanceSegueFromMenu"
        {
            let destinationViewController = segue.destinationViewController as! AC
            
            destinationViewController.daysAgoInformationWasCurrentInteger = daysAgoInformationWasCurrentInteger
        }
        
        if segue.identifier == "backToLoginSegueFromAttendance"
        {
            let destinationViewController = segue.destinationViewController as! TestController
            destinationViewController.versionChoice = versionChoice
        }
    }
    
    
    func daySuffix(date: NSDate) -> String
    {
        let calendar = NSCalendar.currentCalendar()
        let dayOfMonth = calendar.component(NSCalendarUnit.Day, fromDate: date)
        switch dayOfMonth
        {
        case 1: fallthrough
        case 21: fallthrough
        case 31: return "st"
        case 2: fallthrough
        case 22: return "nd"
        case 3: fallthrough
        case 23: return "rd"
        default: return "th"
        }
    }
}

extension UIView
{
    func fadeTransition(duration:CFTimeInterval)
    {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        self.layer.addAnimation(animation, forKey: kCATransitionFade)
    }
}