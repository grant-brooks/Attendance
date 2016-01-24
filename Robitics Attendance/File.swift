//
//  ViewController.swift
//  Class Master
//
//  Created by Grant Goodman on 7/10/15.
//  Copyright © 2016 NEOTechnica Corporation. All rights reserved.
//

import UIKit
import Parse

//-//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-//


/*                                                                  Strings                                                        */


/*! The current user's E-Mail address. */
var currentUserEmailString:     String? = ""
/*! The current user's first name. */
var currentUserFirstNameString: String? = ""
/*! The current user's last name. */
var currentUserLastNameString:  String? = ""
/*! The current user's username. */
var currentUserUserNameString:  String? = ""

/*! The formatted version of the user's text entry in the username and/or password field. */
var finalInputString:           String? = ""

/*! The password of the current user. */
var passwordString:             String? = ""
/*! The username of the current user. */
var userNameString:             String? = ""


//-//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-//


/*                                                           Boolean Values														   */


/*! Boolean value that specifies whether or not the password that was entered was correct. */
var correctPassword:        Bool?
/*! Boolean value that specifies whether or not the username that was entered existed. */
var correctUserName:        Bool?

/*! Boolean value that specifies whether or not the elements of the sign in should be black. */
var isBCB:                  Bool?
/*! Boolean value that specifies whether or not the program is performing a login already. */
var performingLoginAlready: Bool?
/*! Boolean value that specifies whether or not the program is done fetching the desired information about the login credentials. */
var doneFetchingMatches: Bool?
/*! Boolean value that specifies whether or not the user would like his/her credentials to be added to NSUserDefaults. */
var wantsToBeRemembered: Bool?
/*! Boolean value that specifies whether or not the NSUserDefaults data is present. */
var defaultsDataPresent: Bool?


//-//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-//


/*                                                Other Non-Interface Builder Elements                                             */


/*! Integer valye that specifies whether or not a text field is the first responder. */
var firstResponder:  Int = 0
/*! The amount of times that the user has failed to enter correct information. */
var invalidCount:    Int = 0
/*! The amount of times that the user has entered nothing in either text field. */
var whiteSpaceCount: Int = 0


//-//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-//

class TestController: UIViewController, SSRadioButtonControllerDelegate
{
    var waitTimer: NSTimer!
    var unknownErrorAlert: UIAlertController!
    var noNetworkAlert: UIAlertController!
    var noNetwork: Bool! = false
    
    @IBOutlet weak var buildButton: UIButton!
    @IBOutlet weak var ntButton: UIButton!
    
    //let buildNumber = Int(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)! + 1
    let buildNumber = Int(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)!
    var buildIdentifier: String!
    var versionNumber = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    var versionCBI: String!
    var formattedVersionNumber: String!
    
    //-//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-//
    
    
    /*                                              Interface Builder UI Elements                                                  */
    
    
    /*! A black circular button that performs a login. */
    @IBOutlet weak var signInBCB:            BCB!
    
    
    /*! The view that encompasses all of the sign in elements. */
    @IBOutlet weak var behindView:           UIView!
    /*! The view that encompasses the password aspect of the sign in. */
    @IBOutlet weak var enclosingLockView:    UIView!
    /*! The view that encompasses the profile aspect of sign in. */
    @IBOutlet weak var enclosingProfileView: UIView!
    /*! The view that encompasses certain sign in elements. */
    @IBOutlet weak var enclosingSignInView:  UIView!
    
    
    /*! A white circular button that performs a login. */
    @IBOutlet weak var signInWCB:            WCB!
    
    
    /*! An image view that encompasses the whole view, displaying a background image. */
    @IBOutlet weak var backgroundImageView:  UIImageView!
    /*! An image view that displays the password, (lock), image. */
    @IBOutlet weak var passwordImageView:    UIImageView!
    /*! An image view that displays the profile image. */
    @IBOutlet weak var userImageView:        UIImageView!
    
    
    /*! A button that remains hidden to provide space between the password text field and the image view. */
    @IBOutlet weak var hiddenPasswordButton: UIButton!
    /*! A button that remains hidden to provide space between the profile text field and the image view. */
    @IBOutlet weak var hiddenProfileButton:  UIButton!
    
    
    /*! The text field that contains the user's password. */
    @IBOutlet weak var passwordTextField:    UITextField!
    /*! The text field that contains the user's username. */
    @IBOutlet weak var userNameTextField:    UITextField!
    
    var userNames: Array<PFObject> = [PFObject]()
    var passwordArray: Array<PFObject> = [PFObject]()
    
    @IBOutlet weak var rememberMeButton: SSRadioButton!
    
    var versionChoice: Int! = 0
    
    //-//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//-//
    
    
    var radioButtonController: SSRadioButtonsController?
    
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
        
        performingLoginAlready = false
        PFUser.logOut()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let defaultUsername = userDefaults.stringForKey("defaultUsername")
        {
            if let defaultPassword = userDefaults.stringForKey("defaultPassword")
            {
                defaultsDataPresent = true
                
                userNameTextField.text = defaultUsername
                passwordTextField.text = defaultPassword
                
                userFieldDidChange()
                passwordFieldDidChange()
                
                passwordTextField.textColor = colorWithHexString("757678")
                
                wantsToBeRemembered = true
                
                rememberMeButton.selected = true
            }
        }
        
        radioButtonController = SSRadioButtonsController(buttons: rememberMeButton)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        
        //Hide all the elements of the sign in.
        hideAllLoginElements()
        
        //Round all corners on the view that encompasses the elements of the sign in page.
        behindView.layer.cornerRadius = 10.0
        behindView.clipsToBounds = true
        
        //Round the right and left corners on various elements of the sign in page.
        roundCornersOnObject(userNameTextField, sideToRound: "right")
        roundCornersOnObject(passwordTextField, sideToRound: "right")
        roundCornersOnObject(enclosingProfileView, sideToRound: "left")
        roundCornersOnObject(enclosingLockView, sideToRound: "left")
        
        //Set the usernname and password fields' enabled values.
        userNameTextField.enabled = true
        passwordTextField.enabled = true
        
        //Set the tag for the password field.
        passwordTextField.tag = 10
        
        //Show an activity indicator over the view.
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 0.5)
        
        //Set the background of the main view.
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "setImageForBackground", userInfo: nil, repeats: false)
        
        //Add listeners for when the username or password fields change.
        userNameTextField.addTarget(self, action: "userFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        passwordTextField.addTarget(self, action: "passwordFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        passwordTextField.addTarget(self, action: "passwordFieldDidChange", forControlEvents: UIControlEvents.AllEditingEvents)
    }
    
    ///Function that hides all elements of the sign in.
    func hideAllLoginElements()
    {
        //Hide and disable all elements of the username text field.
        userNameTextField.userInteractionEnabled = false
        userNameTextField.alpha = 0
        
        //Hide and disable all elements of the password text field.
        passwordTextField.userInteractionEnabled = false
        passwordTextField.alpha = 0
        
        //Hide and disable all elements of the hidden profile button.
        hiddenProfileButton.userInteractionEnabled = false
        hiddenProfileButton.alpha = 0
        
        //Hide and disable all elements of the hidden password button.
        hiddenPasswordButton.userInteractionEnabled = false
        hiddenPasswordButton.alpha = 0
        
        //Hide and disable all elements of the user image view.
        userImageView.userInteractionEnabled = false
        userImageView.alpha = 0
        
        //Hide and disable all elements of the password image view.
        passwordImageView.userInteractionEnabled = false
        passwordImageView.alpha = 0
        
        //Hide and disable all elements of the sign in white circular button.
        signInWCB.userInteractionEnabled = false
        signInWCB.alpha = 0
        
        //Hide and disable all elements of the sign in black circular button.
        signInBCB.userInteractionEnabled = false
        signInBCB.alpha = 0
        
        //Hide and disable all elements of the enclosing sign in view.
        enclosingSignInView.userInteractionEnabled = false
        enclosingSignInView.alpha = 0
        
        //Hide and disable all elements of the enclosing profile view.
        enclosingProfileView.userInteractionEnabled = false
        enclosingProfileView.alpha = 0
        
        //Hide and disable all elements of the enclosing password, (lock), view.
        enclosingLockView.userInteractionEnabled = false
        enclosingLockView.alpha = 0
        
        //Hide and disable all elements of the information retainer button.
        rememberMeButton.userInteractionEnabled = false
        rememberMeButton.alpha = 0
    }
    
    func showWCBithRememberMeButtonColor(buttonColor: String!)
    {
        self.userNameTextField.userInteractionEnabled = true
        self.userNameTextField.alpha = 1
        
        self.passwordTextField.userInteractionEnabled = true
        self.passwordTextField.alpha = 1
        
        self.hiddenProfileButton.userInteractionEnabled = true
        self.hiddenProfileButton.alpha = 1
        
        self.hiddenPasswordButton.userInteractionEnabled = true
        self.hiddenPasswordButton.alpha = 1
        
        self.userImageView.userInteractionEnabled = true
        self.userImageView.alpha = 1
        
        self.passwordImageView.userInteractionEnabled = true
        self.passwordImageView.alpha = 1
        
        self.signInWCB.userInteractionEnabled = true
        self.signInWCB.alpha = 1
        
        self.enclosingSignInView.userInteractionEnabled = true
        self.enclosingSignInView.alpha = 0.6
        
        self.enclosingProfileView.userInteractionEnabled = true
        self.enclosingProfileView.alpha = 1
        
        self.enclosingLockView.userInteractionEnabled = true
        self.enclosingLockView.alpha = 1
        
        if buttonColor.noWhiteSpaceLowerCaseString == "black"
        {
            rememberMeButton.userInteractionEnabled = true
            rememberMeButton.alpha = 0.9
            rememberMeButton.tintColor = colorWithHexString("1A1A1A")
            rememberMeButton.setTitleColor(colorWithHexString("1A1A1A"), forState: UIControlState.Normal)
            rememberMeButton.circleColor = colorWithHexString("1A1A1A")
        }
        else if buttonColor.noWhiteSpaceLowerCaseString == "white"
        {
            rememberMeButton.userInteractionEnabled = true
            rememberMeButton.alpha = 0.9
            rememberMeButton.tintColor = colorWithHexString("F5F5F5")
            rememberMeButton.setTitleColor(colorWithHexString("F5F5F5"), forState: UIControlState.Normal)
            rememberMeButton.circleColor = colorWithHexString("F5F5F5")
        }
    }
    
    func showBCBWithRememberMeButtonColor(buttonColor: String!)
    {
        self.userNameTextField.userInteractionEnabled = true
        self.userNameTextField.alpha = 1
        
        self.passwordTextField.userInteractionEnabled = true
        self.passwordTextField.alpha = 1
        
        self.hiddenProfileButton.userInteractionEnabled = true
        self.hiddenProfileButton.alpha = 1
        
        self.hiddenPasswordButton.userInteractionEnabled = true
        self.hiddenPasswordButton.alpha = 1
        
        self.userImageView.userInteractionEnabled = true
        self.userImageView.alpha = 1
        
        self.passwordImageView.userInteractionEnabled = true
        self.passwordImageView.alpha = 1
        
        self.signInBCB.userInteractionEnabled = true
        self.signInBCB.alpha = 1
        
        self.enclosingSignInView.userInteractionEnabled = true
        self.enclosingSignInView.alpha = 0.7
        
        self.enclosingProfileView.userInteractionEnabled = true
        self.enclosingProfileView.alpha = 1
        
        self.enclosingLockView.userInteractionEnabled = true
        self.enclosingLockView.alpha = 1
        
        if buttonColor.noWhiteSpaceLowerCaseString == "black"
        {
            rememberMeButton.userInteractionEnabled = true
            rememberMeButton.alpha = 0.9
            rememberMeButton.tintColor = colorWithHexString("1A1A1A")
            rememberMeButton.setTitleColor(colorWithHexString("1A1A1A"), forState: UIControlState.Normal)
            rememberMeButton.circleColor = colorWithHexString("1A1A1A")
        }
        else if buttonColor.noWhiteSpaceLowerCaseString == "white"
        {
            rememberMeButton.userInteractionEnabled = true
            rememberMeButton.alpha = 0.9
            rememberMeButton.tintColor = colorWithHexString("F5F5F5")
            rememberMeButton.setTitleColor(colorWithHexString("F5F5F5"), forState: UIControlState.Normal)
            rememberMeButton.circleColor = colorWithHexString("F5F5F5")
        }
    }
    
    func showUnknownError()
    {
        unknownErrorAlert = UIAlertController(title: "An Error Occurred", message: "An unknown error occured.\n\nPlease try again later or contact your system adminstrator.", preferredStyle: UIAlertControllerStyle.Alert)
        
        unknownErrorAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        presentViewController(unknownErrorAlert, animated: true, completion: nil)
    }
    
    func showNoNetworkError()
    {
        noNetworkAlert = UIAlertController(title: "No Internet Connection", message: "The Internet connection appears to be offline. Please connect to the Internet.", preferredStyle: UIAlertControllerStyle.Alert)
        
        noNetworkAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        presentViewController(noNetworkAlert, animated: true, completion: nil)
    }
    
    func setImageForBackground()
    {
        var randomArray: Array = NSBundle.mainBundle().pathsForResourcesOfType(".png", inDirectory: "Sign In Images")
        let randomPath = arc4random_uniform(UInt32(randomArray.count))
        let randomImage: String = randomArray[Int(randomPath)]
        
        if randomImage.rangeOfString("(B)") != nil
        {
            //println("The image requires a black UI.")
            
            UIApplication.sharedApplication().statusBarStyle = .Default
            UIApplication.sharedApplication().statusBarHidden = false
            
            let toImage = UIImage(named:randomImage)
            UIView.transitionWithView(backgroundImageView,
                duration:3,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: { self.backgroundImageView.image = toImage },
                completion: nil)
            
            UIView.animateWithDuration(1.0, animations:
                {
                    if randomImage.rangeOfString("FS") != nil
                    {
                        self.showWCBithRememberMeButtonColor("white")
                    }
                    else
                    {
                        self.showWCBithRememberMeButtonColor("black")
                    }
            })
            
            signInBCB.hidden = true
            signInBCB.userInteractionEnabled = false
            signInBCB.removeFromSuperview()
            
            isBCB = false
            
            setButtonElementsForWhiteCircularButton(signInWCB, buttonTitle: "SIGN IN", buttonTarget: "goToPage", buttonEnabled: false)
            
            if defaultsDataPresent == true
            {
                self.signInWCB.layer.borderColor = UIColor.whiteColor().CGColor
                self.signInWCB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                
                self.signInWCB.enabled = true
                self.signInWCB.userInteractionEnabled = true
            }
        }
        else if randomImage.rangeOfString("(W)") != nil
        {
            //println("The image requires a white UI.")
            
            if randomImage.rangeOfString("Escalator") != nil
            {
                UIApplication.sharedApplication().statusBarStyle = .Default
                UIApplication.sharedApplication().statusBarHidden = false
            }
            else
            {
                UIApplication.sharedApplication().statusBarStyle = .LightContent
                UIApplication.sharedApplication().statusBarHidden = false
            }
            
            let toImage = UIImage(named:randomImage)
            UIView.transitionWithView(backgroundImageView,
                duration:3,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: { self.backgroundImageView.image = toImage },
                completion: nil)
            
            self.enclosingSignInView.backgroundColor = UIColor.whiteColor()
            
            UIView.animateWithDuration(1.0, animations:
                {
                    self.showBCBWithRememberMeButtonColor("white")
            })
            
            signInWCB.hidden = true
            signInWCB.userInteractionEnabled = false
            signInWCB.removeFromSuperview()
            
            isBCB = true
            
            setButtonElementsForBlackCircularButton(signInBCB, buttonTitle: "SIGN IN", buttonTarget: "goToPage", buttonEnabled: false)
            
            if defaultsDataPresent == true
            {
                self.signInBCB.layer.borderColor = UIColor.blackColor().CGColor
                self.signInBCB.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                
                self.signInBCB.enabled = true
                self.signInBCB.userInteractionEnabled = true
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    func signUpUser()
    {
        //performSegueWithIdentifier("signUpSegue", sender: self)
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
    
    func getFirstResponder()
    {
        //Get the current keyboard that is the first responder, and set the firstResponder boolean value accordingly.
        if self.userNameTextField.isFirstResponder()
        {
            firstResponder = 0
            firstResponder = 1
        }
        else if self.passwordTextField.isFirstResponder()
        {
            firstResponder = 1
        }
    }
    
    /*! UIAlertView Functions. */
    
    ///Function that asks the user if he or she would like to set up an account with a username that does not exist, yet.
    func showNoUserAlert()
    {
        PKHUD.sharedHUD.hide(afterDelay: 0.0)
        self.waitTimer.invalidate()
        
        //Ask whether the user would like to set-up an account or not.
        let userNameAttemptsString: String = "There doesn't seem to be an account with the username: '\(self.userNameTextField.text!)'.\n\nPlease contact your system administrator for assistance.\n\n(Code: 101)"
        
        let noUserAlert = UIAlertController(title: "Credentials Error", message: userNameAttemptsString, preferredStyle: UIAlertControllerStyle.Alert)
        
        noUserAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        self.presentViewController(noUserAlert, animated: true, completion: nil)
    }
    
    
    func showInvalidCredentialsAlert()
    {
        let invalidCredentialsAlert = UIAlertController(title: "Having Trouble?", message: "It looks like you might be having a bit of trouble accessing your account.\n\nIf you have forgotten your password, contact your system administrator.\n\n(Code: 101)", preferredStyle: UIAlertControllerStyle.Alert)
        
        invalidCredentialsAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        self.presentViewController(invalidCredentialsAlert, animated: true, completion: nil)
    }
    
    /*! Other Functions. */
    
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

    @IBAction func rememberMeButton(sender: AnyObject)
    {
        if rememberMeButton.selected == true
        {
            print("deselected")
            wantsToBeRemembered = false
            
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "defaultUsername")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "defaultPassword")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        else
        {
            print("selected")
            wantsToBeRemembered = true
            
            NSUserDefaults.standardUserDefaults().setObject(userNameTextField.text, forKey: "defaultUsername")
            NSUserDefaults.standardUserDefaults().setObject(passwordTextField.text, forKey: "defaultPassword")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func goToPage()
    {
        //If the username or password fields are first responders, resign them.
        if (userNameTextField.isFirstResponder() || passwordTextField.isFirstResponder())
        {
            userNameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
        }
        
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        
        PKHUD.sharedHUD.hide(afterDelay: 25.0)
        self.waitTimer = NSTimer.scheduledTimerWithTimeInterval(26.0, target: self, selector: "showUnknownError", userInfo: nil, repeats: false)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let query: PFQuery = PFUser.query()!
            
            userNameString = self.userNameTextField.text!.lowercaseString
            passwordString = self.passwordTextField.text!
            
            query.whereKey("userPassword", equalTo: passwordString!)
            query.whereKey("username", equalTo: userNameString!)
            
            //query.findObjectsInBackground()
            
            dispatch_async(dispatch_get_main_queue()) {
                query.findObjectsInBackgroundWithBlock({ (results: [PFObject]?, error: NSError?) -> Void in
                    if error != nil
                    {
                        if error!.code == 100
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.showNoNetworkError()
                                PKHUD.sharedHUD.hide(afterDelay: 0.0)
                                self.waitTimer.invalidate()
                            }
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.showUnknownError()
                                PKHUD.sharedHUD.hide(afterDelay: 0.0)
                                self.waitTimer.invalidate()
                            }
                        }

                    }
                })
            }
            
            //Check if the formatted username and password strings are blank.
            if self.userNameTextField.text!.noWhiteSpaceLowerCaseString == "" && self.passwordTextField.text!.noWhiteSpaceLowerCaseString == ""
            {
                PKHUD.sharedHUD.hide(afterDelay: 0.0)
                self.waitTimer.invalidate()
                
                //Add one to the amount of times this has happened.
                whiteSpaceCount++
                
                //If it has happened three or more times, show the 'Enter Credentials' HUD alert.
                //Otherwise, increase the size of the username and/or password fields as a sign of emphasis to the user depending on which field(s) are empty.
                //If there is text entered in both fields, attempt a login for the user.
                if (whiteSpaceCount >= 3)
                {
                    whiteSpaceCount = 0
                    
                    NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "showEnterCredentialsAlert", userInfo: nil, repeats: false)
                }
                else
                {
                    self.userNameTextField.frame = CGRectMake(self.userNameTextField.frame.origin.x - 16 , self.userNameTextField.frame.origin.y, 322, self.userNameTextField.frame.size.height)
                    self.userNameTextField.transform = CGAffineTransformMakeScale(1, 1.1)
                    self.hiddenProfileButton.transform = CGAffineTransformMakeScale(1,1.1)
                    self.enclosingProfileView.transform = CGAffineTransformMakeScale(1,1.1)
                    self.userNameTextField.frame = CGRectMake(self.userNameTextField.frame.origin.x * 1.1, self.userNameTextField.frame.origin.y, 354.2, self.userNameTextField.frame.size.height)
                    
                    self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x - 16, self.passwordTextField.frame.origin.y, 322, self.passwordTextField.frame.size.height)
                    self.passwordTextField.transform = CGAffineTransformMakeScale(1,1.1)
                    self.hiddenPasswordButton.transform = CGAffineTransformMakeScale(1,1.1)
                    self.enclosingLockView.transform = CGAffineTransformMakeScale(1,1.1)
                    self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x * 1.1, self.passwordTextField.frame.origin.y, 354.2, self.passwordTextField.frame.size.height)
                    
                    UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations:
                        {
                            self.hiddenProfileButton.transform = CGAffineTransformIdentity
                            self.userNameTextField.transform = CGAffineTransformIdentity
                            self.enclosingProfileView.transform = CGAffineTransformIdentity
                            
                            self.hiddenPasswordButton.transform = CGAffineTransformIdentity
                            self.passwordTextField.transform = CGAffineTransformIdentity
                            self.enclosingLockView.transform = CGAffineTransformIdentity
                            
                        },
                        completion:
                        {
                            finished in
                            if finished
                            {
                                self.reRespond()
                            }
                    })
                }
                
            }
            else if self.userNameTextField.text!.noWhiteSpaceLowerCaseString == ""
            {
                PKHUD.sharedHUD.hide(afterDelay: 0.0)
                self.waitTimer.invalidate()
                
                whiteSpaceCount++
                
                if (whiteSpaceCount >= 3)
                {
                    whiteSpaceCount = 0
                    
                    NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "showEnterUserNameAlert", userInfo: nil, repeats: false)
                }
                else
                {
                    self.userNameTextField.frame = CGRectMake(self.userNameTextField.frame.origin.x - 16, self.userNameTextField.frame.origin.y, 322, self.userNameTextField.frame.size.height)
                    self.userNameTextField.transform = CGAffineTransformMakeScale(1,1.1)
                    self.hiddenProfileButton.transform = CGAffineTransformMakeScale(1,1.1)
                    self.enclosingProfileView.transform = CGAffineTransformMakeScale(1,1.1)
                    self.userNameTextField.frame = CGRectMake(self.userNameTextField.frame.origin.x * 1.1, self.userNameTextField.frame.origin.y, 354.2, self.userNameTextField.frame.size.height)
                    
                    UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations:
                        {
                            self.hiddenProfileButton.transform = CGAffineTransformIdentity
                            self.userNameTextField.transform = CGAffineTransformIdentity
                            self.enclosingProfileView.transform = CGAffineTransformIdentity
                            
                        }, completion:
                        {
                            finished in
                            if finished
                            {
                                self.reRespond()
                            }
                    })
                }
            }
            else if self.passwordTextField.text!.noWhiteSpaceLowerCaseString == "" && self.userNameTextField.text!.noWhiteSpaceLowerCaseString != ""
            {
                PKHUD.sharedHUD.hide(afterDelay: 0.0)
                self.waitTimer.invalidate()
                
                whiteSpaceCount++
                
                if (whiteSpaceCount >= 3)
                {
                    whiteSpaceCount = 0
                    
                    NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "showEnterPasswordAlert", userInfo: nil, repeats: false)
                }
                else
                {
                    self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x - 16, self.passwordTextField.frame.origin.y, 322, self.passwordTextField.frame.size.height)
                    self.passwordTextField.transform = CGAffineTransformMakeScale(1,1.1)
                    self.hiddenPasswordButton.transform = CGAffineTransformMakeScale(1,1.1)
                    self.enclosingLockView.transform = CGAffineTransformMakeScale(1,1.1)
                    self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x * 1.1, self.passwordTextField.frame.origin.y, 354.2, self.passwordTextField.frame.size.height)
                    
                    UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations:
                        {
                            self.hiddenPasswordButton.transform = CGAffineTransformIdentity
                            self.passwordTextField.transform = CGAffineTransformIdentity
                            self.enclosingLockView.transform = CGAffineTransformIdentity
                            
                        },
                        completion:
                        {
                            finished in
                            if finished
                            {
                                self.reRespond()
                            }
                    })
                }
            }
            else if self.userNameTextField.text!.noWhiteSpaceLowerCaseString != "" && self.passwordTextField.text!.noWhiteSpaceLowerCaseString != ""
            {
                PKHUD.sharedHUD.hide(afterDelay: 0.0)
                self.waitTimer.invalidate()
                
                if performingLoginAlready != true
                {
                    //println("Text Field Returned.")
                    
                    userNameString = self.userNameTextField.text!
                    passwordString = self.passwordTextField.text!
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        
                        let query: PFQuery = PFUser.query()!
                        
                        userNameString = self.userNameTextField.text!.lowercaseString
                        
                        query.whereKey("username", equalTo: userNameString!)
                        
                        query.findObjectsInBackgroundWithBlock({ (results: [PFObject]?, error: NSError?) -> Void in
                            if error == nil
                            {
                                self.userNames = results!
                                
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    if self.userNames.count >= 1
                                    {
                                        //                                self.userNameTextField.textColor = colorWithHexString("27AE60")
                                        //                                self.userImageView.image = UIImage(named: "Correct-Profile.png")
                                        correctUserName = true
                                    }
                                    else
                                    {
                                        //                                self.userNameTextField.textColor = colorWithHexString("E74C3C")
                                        //                                self.userImageView.image = UIImage(named: "Incorrect-Profile.png")
                                        correctUserName = false
                                    }
                                    
                                }
                            }
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                
                                if self.userNames.count == 0
                                {
                                    //Set the times that a field has been invalid to none.
                                    invalidCount = 0
                                    
                                    //Shake all aspects of the username field.
                                    self.shakeView(self.userNameTextField)
                                    self.shakeView(self.userImageView)
                                    self.shakeView(self.hiddenProfileButton)
                                    self.shakeView(self.enclosingProfileView)
                                    
                                    //Shake all aspects of the password field.
                                    self.shakeView(self.passwordTextField)
                                    self.shakeView(self.passwordImageView)
                                    self.shakeView(self.hiddenPasswordButton)
                                    self.shakeView(self.enclosingLockView)
                                    
                                    self.showNoUserAlert()
                                }
                                else
                                {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        
                                        if self.userNames[0].objectForKey("userPassword") as! String == self.passwordTextField.text!
                                        {
                                            PKHUD.sharedHUD.hide(afterDelay: 0.0)
                                            self.waitTimer.invalidate()
                                            
                                            NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "animateLogin", userInfo: nil, repeats: false)
                                        }
                                        else
                                        {
                                            invalidCount++
                                            
                                            PKHUD.sharedHUD.hide(afterDelay: 0.0)
                                            self.waitTimer.invalidate()
                                            
                                            NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "animateInvalidCredentials", userInfo: nil, repeats: false)
                                        }
                                        
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func animateInvalidCredentials()
    {
        //If a field or fiels do not have information in it/them for the third time, show a login failure HUD alert.
        //Otherwise, allow the keyboard to become the first responder again.
        if invalidCount >= 3
        {
            invalidCount = 0
            
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showFailure", userInfo: nil, repeats: false)
        }
        else
        {
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "reRespond", userInfo: nil, repeats: false)
        }
        
        correctPassword = false
        
        UIView.transitionWithView(self.passwordTextField, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.passwordTextField.textColor = colorWithHexString("E74C3C")
            
            self.passwordImageView.image = UIImage(named: "Incorrect-Password.png")
            
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.passwordImageView.layer.addAnimation(transition, forKey: nil)
            }, completion: {finished in
                
                if finished {self.shakeView(self.passwordTextField)
                    self.shakeView(self.passwordImageView)
                    self.shakeView(self.hiddenPasswordButton)
                    self.shakeView(self.enclosingLockView)
                    self.passwordTextField.text = ""
                    
                    if isBCB == true
                    {
                        self.signInBCB.layer.borderColor = UIColor.grayColor().CGColor
                        self.signInBCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                        
                        self.signInBCB.enabled = false
                        self.signInBCB.userInteractionEnabled = false
                    }
                    else if isBCB == false
                    {
                        self.signInWCB.layer.borderColor = UIColor.grayColor().CGColor
                        self.signInWCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                        
                        self.signInWCB.enabled = false
                        self.signInWCB.userInteractionEnabled = false
                    }
                    
                    UIView.transitionWithView(self.passwordTextField, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        self.passwordTextField.textColor = colorWithHexString("757678")
                        
                        self.passwordImageView.image = UIImage(named: "Lock")
                        
                        let transition: CATransition = CATransition()
                        transition.duration = 0.5
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.type = kCATransitionFade
                        self.passwordImageView.layer.addAnimation(transition, forKey: nil)
                        }, completion: {finished in
                            
                            if finished {}})}})
    }
    
    func animateLogin()
    {
        UIView.transitionWithView(self.userNameTextField, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.userNameTextField.textColor = colorWithHexString("27AE60")
            
            self.userImageView.image = UIImage(named: "Correct-Profile.png")
            
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.userImageView.layer.addAnimation(transition, forKey: nil)
            
            }, completion: {finished in
                
                if finished {
                    
                    UIView.transitionWithView(self.passwordTextField, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        self.passwordTextField.textColor = colorWithHexString("27AE60")
                        
                        //self.userImageView.image = UIImage(named: "Check.png")
                        
                        let transition: CATransition = CATransition()
                        transition.duration = 0.5
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.type = kCATransitionFade
                        self.userImageView.layer.addAnimation(transition, forKey: nil)
                        
                        
                        self.passwordImageView.image = UIImage(named: "Correct-Password.png")
                        
                        let transition2: CATransition = CATransition()
                        transition2.duration = 0.5
                        transition2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition2.type = kCATransitionFade
                        self.passwordImageView.layer.addAnimation(transition2, forKey: nil)
                        }, completion: {finished in
                            
                            if finished {//self.passwordImageView.image = UIImage(named: "Check.png")
                                
                                let transition2: CATransition = CATransition()
                                transition2.duration = 1.0
                                transition2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                transition2.type = kCATransitionFade
                                self.passwordImageView.layer.addAnimation(transition2, forKey: nil)
                            }})}})
        
        
        correctUserName = true
        correctPassword = true
        self.signInUser()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userFieldDidChange()
    {
        if self.userNameTextField.text!.noWhiteSpaceLowerCaseString != "" && self.passwordTextField.text!.noWhiteSpaceLowerCaseString != ""
        {
            //println("Both fields are full.")
            
            if isBCB == true
            {
                self.signInBCB.layer.borderColor = UIColor.blackColor().CGColor
                self.signInBCB.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                
                self.signInBCB.enabled = true
                self.signInBCB.userInteractionEnabled = true
            }
            else if isBCB == false
            {
                self.signInWCB.layer.borderColor = UIColor.whiteColor().CGColor
                self.signInWCB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                
                self.signInWCB.enabled = true
                self.signInWCB.userInteractionEnabled = true
            }
        }
        else if self.userNameTextField.text!.noWhiteSpaceLowerCaseString == ""
        {
            if isBCB == true
            {
                self.signInBCB.layer.borderColor = UIColor.grayColor().CGColor
                self.signInBCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                
                self.signInBCB.enabled = false
                self.signInBCB.userInteractionEnabled = false
            }
            else if isBCB == false
            {
                self.signInWCB.layer.borderColor = UIColor.grayColor().CGColor
                self.signInWCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                
                self.signInWCB.enabled = false
                self.signInWCB.userInteractionEnabled = false
            }
            
            self.userNameTextField.textColor = colorWithHexString("757678")
            self.userImageView.image = UIImage(named: "Profile")
            
            userNameTextField.text = ""
        }
        else
        {
            if isBCB == true
            {
                self.signInBCB.layer.borderColor = UIColor.grayColor().CGColor
                self.signInBCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                
                self.signInBCB.enabled = false
                self.signInBCB.userInteractionEnabled = false
            }
            else if isBCB == false
            {
                self.signInWCB.layer.borderColor = UIColor.grayColor().CGColor
                self.signInWCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                
                self.signInWCB.enabled = false
                self.signInWCB.userInteractionEnabled = false
            }
            
            self.userNameTextField.textColor = colorWithHexString("757678")
            
            self.userImageView.image = UIImage(named: "Profile")
        }
        
        //If the formatted username string is blank, change the color of the text and the image to gray/black.
        //Otherwise, check if the current text matches a username in the database. If so or not, act accordingly.
        if self.userNameTextField.text!.noWhiteSpaceLowerCaseString.isEmpty
        {
            userNameTextField.textColor = colorWithHexString("00000")
            userImageView.image = UIImage(named: "Profile")
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                let query: PFQuery = PFUser.query()!
                
                userNameString = self.userNameTextField.text!.lowercaseString
                
                query.whereKey("username", equalTo: userNameString!)
                
                query.findObjectsInBackgroundWithBlock({ (results: [PFObject]?, error: NSError?) -> Void in
                    if error == nil
                    {
                        let userNames: Array = results!
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            if userNames.count >= 1
                            {
                                //                                self.userNameTextField.textColor = colorWithHexString("27AE60")
                                //                                self.userImageView.image = UIImage(named: "Correct-Profile.png")
                                correctUserName = true
                            }
                            else
                            {
                                //                                self.userNameTextField.textColor = colorWithHexString("E74C3C")
                                //                                self.userImageView.image = UIImage(named: "Incorrect-Profile.png")
                                correctUserName = false
                            }
                            
                        }
                    }
                })
            }
        }
        
        
    }
    
    func passwordFieldDidChange()
    {
        if self.userNameTextField.text!.noWhiteSpaceLowerCaseString != "" && self.passwordTextField.text!.noWhiteSpaceLowerCaseString != ""
        {
            //println("Both fields are full.")
            
            if isBCB == true
            {
                self.signInBCB.layer.borderColor = UIColor.blackColor().CGColor
                self.signInBCB.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                
                self.signInBCB.enabled = true
                self.signInBCB.userInteractionEnabled = true
            }
            else if isBCB == false
            {
                self.signInWCB.layer.borderColor = UIColor.whiteColor().CGColor
                self.signInWCB.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                
                self.signInWCB.enabled = true
                self.signInWCB.userInteractionEnabled = true
            }
        }
        else if self.passwordTextField.text!.noWhiteSpaceLowerCaseString == ""
        {
            if isBCB == true
            {
                self.signInBCB.layer.borderColor = UIColor.grayColor().CGColor
                self.signInBCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                
                self.signInBCB.enabled = false
                self.signInBCB.userInteractionEnabled = false
            }
            else if isBCB == false
            {
                self.signInWCB.layer.borderColor = UIColor.grayColor().CGColor
                self.signInWCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                
                self.signInWCB.enabled = false
                self.signInWCB.userInteractionEnabled = false
            }
            
            self.passwordTextField.textColor = colorWithHexString("757678")
            
            self.passwordImageView.image = UIImage(named: "Lock")
            
            passwordTextField.text = ""
        }
        else
        {
            if isBCB == true
            {
                self.signInBCB.layer.borderColor = UIColor.grayColor().CGColor
                self.signInBCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                
                self.signInBCB.enabled = false
                self.signInBCB.userInteractionEnabled = false
            }
            else if isBCB == false
            {
                self.signInWCB.layer.borderColor = UIColor.grayColor().CGColor
                self.signInWCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                
                self.signInWCB.enabled = false
                self.signInWCB.userInteractionEnabled = false
            }
            
            self.passwordTextField.textColor = colorWithHexString("757678")
            
            self.passwordImageView.image = UIImage(named: "Lock")
        }
    }
    
    func performLogin()
    {
        //Get the current keyboard that is the first responder.
        if userNameTextField.isFirstResponder()
        {
            firstResponder = 0
            firstResponder = 1
        }
        else if passwordTextField.isFirstResponder()
        {
            firstResponder = 1
        }
        
        //Set the color of the username and password fields to gray/black.
        userNameTextField.textColor = colorWithHexString("00000")
        userImageView.image = UIImage(named: "Profile")
        
        passwordTextField.textColor = colorWithHexString("00000")
        passwordImageView.image = UIImage(named: "Lock")
        
        //Set the current credentials strings to the current user's information.
        currentUserFirstNameString = PFUser.currentUser()?.objectForKey("firstName") as? String
        currentUserLastNameString = PFUser.currentUser()?.objectForKey("lastName") as? String
        currentUserEmailString = PFUser.currentUser()?.objectForKey("email") as? String
        currentUserUserNameString = PFUser.currentUser()?.objectForKey("username") as? String
        
        //println("First Name of User: '\(currentUserFirstNameString!)'.")
        
        self.performSegueWithIdentifier("menuSegueFromLogin", sender: self)
        
        ////println("username and Password Were Correct.")
        
        //Clear the text in the username and password fields.
        userNameTextField.text = ""
        passwordTextField.text = ""
        
        //If the username or password fields are first responders, resign them.
        if (userNameTextField.isFirstResponder() || passwordTextField.isFirstResponder())
        {
            userNameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
        }
    }
    
    func shakeViews()
    {
        //Increase the times that a field has been invalid by one.
        invalidCount++
        
        //Set the 'performingLoginAlready' boolean value to 'NO'.
        performingLoginAlready = false
        
        //Determine what fields are correct and what are incorrect, and shake the required field(s) accordingly.
        //If both fields are incorrect, ask the user wether he or she would like to set-up an account.
        if (correctUserName == true && correctPassword == false)
        {
            //Shake all aspects of the password field.
            shakeView(passwordTextField)
            shakeView(passwordImageView)
            shakeView(hiddenPasswordButton)
            shakeView(enclosingLockView)
        }
        else if (correctUserName == false && correctPassword == false)
        {
            //Set the times that a field has been invalid to none.
            invalidCount = 0
            
            //Shake all aspects of the username field.
            shakeView(userNameTextField)
            shakeView(userImageView)
            shakeView(hiddenProfileButton)
            shakeView(enclosingProfileView)
            
            //Shake all aspects of the password field.
            shakeView(passwordTextField)
            shakeView(passwordImageView)
            shakeView(hiddenPasswordButton)
            shakeView(enclosingLockView)
            
            PKHUD.sharedHUD.hide(afterDelay: 0.0)
            self.waitTimer.invalidate()
            
            //Ask wether the user would like to set-up an account or not.
            let userNameAttemptsString: String = "There doesn't seem to be an account with the username: '\(userNameTextField.text)'.\n\nPlease contact your system administrator for assistance.\n\n(Code: 101)"
            
            let credentialsAlert = UIAlertController(title: "Credentials Error", message: userNameAttemptsString, preferredStyle: UIAlertControllerStyle.Alert)
            
            credentialsAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
            presentViewController(credentialsAlert, animated: true, completion: nil)
        }
        else
        {
            //Shake all aspects of the username field.
            shakeView(userNameTextField)
            shakeView(userImageView)
            shakeView(hiddenProfileButton)
            shakeView(enclosingProfileView)
            
            //Shake all aspects of the password field.
            shakeView(passwordTextField)
            shakeView(passwordImageView)
            shakeView(hiddenPasswordButton)
            shakeView(enclosingLockView)
        }
        
        //If a field or fiels do not have information in it/them for the third time, show a login failure HUD alert.
        //Otherwise, allow the keyboard to become the first responder again.
        if invalidCount >= 3
        {
            invalidCount = 0
            
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showFailure", userInfo: nil, repeats: false)
        }
        else
        {
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "reRespond", userInfo: nil, repeats: false)
        }
    }
    
    func reRespond()
    {
        //Enable the username and password fields for any sign out commands to parse.
        userNameTextField.enabled = true
        passwordTextField.enabled = true
        
        //Set the delegate for the username and password fields.
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        //Remove the text from the password field for security's sake.
        passwordTextField.text = ""
        
        //Get which field was the first responder, and allow the keyboard to become the first responder again.
        if firstResponder == 0
        {
            userNameTextField.becomeFirstResponder()
        }
        
        if firstResponder == 1
        {
            passwordTextField.becomeFirstResponder()
        }
        
    }
    
    func shakeView (viewToShake: UIView)
    {
        let t: CGFloat = 2.0
        
        let translateRight: CGAffineTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0)
        let translateLeft: CGAffineTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0)
        
        viewToShake.transform = translateLeft
        
        UIView.animateWithDuration(0.07, delay: 0.0, options: [UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.Repeat], animations: {
            
            UIView.setAnimationRepeatCount(2.0)
            viewToShake.transform = translateRight
            
            }, completion: { finished in
                if finished {
                    UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {}, completion: { finished in
                        if finished {
                            viewToShake.transform = CGAffineTransformIdentity
                        }})
                }
        })
    }
    
    func performTeacherSegue()
    {
        //Perform the 'boardMemberSegue' segue.
        performSegueWithIdentifier("teacherSegue", sender: self)
    }
    
    func dismissHUD()
    {
        NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "shakeViews", userInfo: nil, repeats: false)
    }
    
    func signInUser()
    {
        if performingLoginAlready != true
        {
            performingLoginAlready = true
            
            if userNameTextField.isFirstResponder()
            {
                firstResponder = 0
            }
            else if passwordTextField.isFirstResponder()
            {
                firstResponder = 1
            }
            
            PFUser.logInWithUsernameInBackground(userNameTextField.text!, password: passwordTextField.text!) { (PFUser, NSError) -> Void in
                
                var user = PFUser
                var error = NSError
                
                if error?.code == 101
                {
                    if self.userNameTextField.isFirstResponder() || self.passwordTextField.isFirstResponder()
                    {
                        self.userNameTextField.resignFirstResponder()
                        self.passwordTextField.resignFirstResponder()
                    }
                    
                    NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "dismissHUD", userInfo: nil, repeats: false)
                }
                else if error?.code == 100
                {
                    if self.userNameTextField.isFirstResponder() || self.passwordTextField.isFirstResponder()
                    {
                        self.userNameTextField.resignFirstResponder()
                        self.passwordTextField.resignFirstResponder()
                    }
                    
                    let networkErrorAlert = UIAlertController(title: "Network Error", message: "The Internet connection appears to be offline. Please connect to the Internet. (Code: 100)", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    networkErrorAlert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                    self.presentViewController(networkErrorAlert, animated: true, completion: nil)
                }
                else if error?.code != 101 && error?.code != nil
                {
                    if self.userNameTextField.isFirstResponder() || self.passwordTextField.isFirstResponder()
                    {
                        self.userNameTextField.resignFirstResponder()
                        self.passwordTextField.resignFirstResponder()
                    }
                    
                    let invalidCredentialsAlert = UIAlertController(title: "Something Went Wrong", message: "Your username or password was invalid. Do you have an account? (Code: \(error?.code)).", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    invalidCredentialsAlert.addAction(UIAlertAction(title: "Try Again", style: .Cancel, handler: nil))
                    invalidCredentialsAlert.addAction(UIAlertAction(title: "Sign Up", style: .Default, handler: nil))
                    self.presentViewController(invalidCredentialsAlert, animated: true, completion: nil)
                }
                else
                {
                    if wantsToBeRemembered == true
                    {
                        NSUserDefaults.standardUserDefaults().setObject(PFUser!.username, forKey: "defaultUsername")
                        NSUserDefaults.standardUserDefaults().setObject(PFUser!.objectForKey("userPassword"), forKey: "defaultPassword")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                    else
                    {
                        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "defaultUsername")
                        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "defaultPassword")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                    
                    NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "showSuccess", userInfo: nil, repeats: false)
                }
            }
        }
        
        func showSuccess()
        {
            //Display a 'Success!' HUD alert to the user and afterwards perform a login.
            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 1)
            
            if isBCB == true
            {
                self.signInBCB.layer.borderColor = UIColor.grayColor().CGColor
                self.signInBCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                
                self.signInBCB.enabled = false
                self.signInBCB.userInteractionEnabled = false
            }
            else if isBCB == false
            {
                self.signInWCB.layer.borderColor = UIColor.grayColor().CGColor
                self.signInWCB.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                
                self.signInWCB.enabled = false
                self.signInWCB.userInteractionEnabled = false
            }
            
            NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "performLogin", userInfo: nil, repeats: false)
        }
    }
    
    func showEnterUserNameAlert()
    {
        //Display an error to the user and afterwards allow the keyboard to become the first responder again.
        PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Enter Username", image: PKHUDAssets.crossImage)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1)
        
        NSTimer.scheduledTimerWithTimeInterval(1.7, target: self, selector: "reRespond", userInfo: nil, repeats: false)
    }
    
    
    func showEnterPasswordAlert()
    {
        //Display an error to the user and afterwards allow the keyboard to become the first responder again.
        PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Enter Password", image: PKHUDAssets.crossImage)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1)
        
        NSTimer.scheduledTimerWithTimeInterval(1.7, target: self, selector: "reRespond", userInfo: nil, repeats: false)
        
    }
    
    func showEnterCredentialsAlert()
    {
        //Display an error to the user and afterwards allow the keyboard to become the first responder again.
        PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Evaluate All Fields", image: PKHUDAssets.crossImage)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1)
        
        NSTimer.scheduledTimerWithTimeInterval(1.7, target: self, selector: "reRespond", userInfo: nil, repeats: false)
    }
    
    func showSuccess()
    {
        //Display a 'Success!' HUD alert to the user and afterwards perform a login.
        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1)
        
        NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "performLogin", userInfo: nil, repeats: false)
    }
    
    func showFailure()
    {
        //Display an error to the user and afterwards show an 'invalid credentials' alert view.
        PKHUD.sharedHUD.contentView = PKHUDSubtitleView(subtitle: "Invalid Credentials", image: PKHUDAssets.crossImage)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1)
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "showInvalidCredentialsAlert", userInfo: nil, repeats: false)
    }
}


func colorWithHexString (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substringFromIndex(1)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.grayColor()
    }
    
    let rString = (cString as NSString).substringToIndex(2)
    let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

extension TestController : UITextFieldDelegate
{
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        //Get the current keyboard that is the first responder.
        if userNameTextField.isFirstResponder()
        {
            firstResponder = 0
        }
        else if passwordTextField.isFirstResponder()
        {
            firstResponder = 1
        }
        
        //If the text field's tag is '10', symbolizing the password field, change the color of the text and image to gray/black.
        if (textField.tag == 10)
        {
            passwordTextField.textColor = colorWithHexString("00000")
            passwordImageView.image = UIImage(named: "Lock")
        }
        
        return true
    }
    
    func captureScreen() -> UIImage
    {
        var window: UIWindow? = UIApplication.sharedApplication().keyWindow
        window = UIApplication.sharedApplication().windows[0]
        UIGraphicsBeginImageContextWithOptions(window!.frame.size, window!.opaque, 0.0)
        window!.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        //Get the current keyboard that is the first responder.
        if userNameTextField.isFirstResponder()
        {
            firstResponder = 0
            firstResponder = 1
        }
        else if passwordTextField.isFirstResponder()
        {
            firstResponder = 1
        }
        
        //Check if the formatted username and password strings are blank.
        if passwordTextField.text!.noWhiteSpaceLowerCaseString == "" && userNameTextField.text!.noWhiteSpaceLowerCaseString == ""
        {
            //Add one to the amount of times this has happened.
            whiteSpaceCount++
            
            //If it has happened three or more times, show the 'Enter Credentials' HUD alert.
            //Otherwise, increase the size of the username and/or password fields as a sign of emphasis to the user depending on which field(s) are empty.
            //If there is text entered in both fields, attempt a login for the user.
            if (whiteSpaceCount >= 3)
            {
                whiteSpaceCount = 0
                
                NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "showEnterCredentialsAlert", userInfo: nil, repeats: false)
            }
            else
            {
                self.userNameTextField.frame = CGRectMake(self.userNameTextField.frame.origin.x - 16 , self.userNameTextField.frame.origin.y, 322, self.userNameTextField.frame.size.height)
                self.userNameTextField.transform = CGAffineTransformMakeScale(1, 1.1)
                self.hiddenProfileButton.transform = CGAffineTransformMakeScale(1,1.1)
                self.enclosingProfileView.transform = CGAffineTransformMakeScale(1,1.1)
                self.userNameTextField.frame = CGRectMake(self.userNameTextField.frame.origin.x * 1.1, self.userNameTextField.frame.origin.y, 354.2, self.userNameTextField.frame.size.height)
                
                self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x - 16, self.passwordTextField.frame.origin.y, 322, self.passwordTextField.frame.size.height)
                self.passwordTextField.transform = CGAffineTransformMakeScale(1,1.1)
                self.hiddenPasswordButton.transform = CGAffineTransformMakeScale(1,1.1)
                self.enclosingLockView.transform = CGAffineTransformMakeScale(1,1.1)
                self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x * 1.1, self.passwordTextField.frame.origin.y, 354.2, self.passwordTextField.frame.size.height)
                
                UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations:
                    {
                        self.hiddenProfileButton.transform = CGAffineTransformIdentity
                        self.userNameTextField.transform = CGAffineTransformIdentity
                        self.enclosingProfileView.transform = CGAffineTransformIdentity
                        
                        self.hiddenPasswordButton.transform = CGAffineTransformIdentity
                        self.passwordTextField.transform = CGAffineTransformIdentity
                        self.enclosingLockView.transform = CGAffineTransformIdentity
                        
                    },
                    completion:{finished in if finished {self.reRespond()}})
            }
        }
        else if self.userNameTextField.text!.noWhiteSpaceLowerCaseString == ""
        {
            whiteSpaceCount++
            
            if (whiteSpaceCount >= 3)
            {
                whiteSpaceCount = 0
                
                NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "showEnterUserNameAlert", userInfo: nil, repeats: false)
            }
            else
            {
                self.userNameTextField.frame = CGRectMake(self.userNameTextField.frame.origin.x - 16, self.userNameTextField.frame.origin.y, 322, self.userNameTextField.frame.size.height)
                self.userNameTextField.transform = CGAffineTransformMakeScale(1,1.1)
                self.hiddenProfileButton.transform = CGAffineTransformMakeScale(1,1.1)
                self.enclosingProfileView.transform = CGAffineTransformMakeScale(1,1.1)
                self.userNameTextField.frame = CGRectMake(self.userNameTextField.frame.origin.x * 1.1, self.userNameTextField.frame.origin.y, 354.2, self.userNameTextField.frame.size.height)
                
                UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations:
                    {
                        self.hiddenProfileButton.transform = CGAffineTransformIdentity
                        self.userNameTextField.transform = CGAffineTransformIdentity
                        self.enclosingProfileView.transform = CGAffineTransformIdentity
                        
                    }, completion:
                    {
                        finished in
                        if finished
                        {
                            self.reRespond()
                        }
                })
            }
        }
        else if self.passwordTextField.text!.noWhiteSpaceLowerCaseString == ""
        {
            whiteSpaceCount++
            
            if (whiteSpaceCount >= 3)
            {
                whiteSpaceCount = 0
                
                NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "showEnterPasswordAlert", userInfo: nil, repeats: false)
            }
            else
            {
                self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x - 16, self.passwordTextField.frame.origin.y, 322, self.passwordTextField.frame.size.height)
                self.passwordTextField.transform = CGAffineTransformMakeScale(1,1.1)
                self.hiddenPasswordButton.transform = CGAffineTransformMakeScale(1,1.1)
                self.enclosingLockView.transform = CGAffineTransformMakeScale(1,1.1)
                self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x * 1.1, self.passwordTextField.frame.origin.y, 354.2, self.passwordTextField.frame.size.height)
                
                UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations:
                    {
                        self.hiddenPasswordButton.transform = CGAffineTransformIdentity
                        self.passwordTextField.transform = CGAffineTransformIdentity
                        self.enclosingLockView.transform = CGAffineTransformIdentity
                        
                    },
                    completion:
                    {
                        finished in
                        if finished
                        {
                            self.reRespond()
                        }
                })
            }
        }
        else if userNameTextField.text!.noWhiteSpaceLowerCaseString != "" && passwordTextField.text!.noWhiteSpaceLowerCaseString != ""
        {
            if performingLoginAlready != true
            {
                //println("Text Field Returned.")
                
                userNameString = userNameTextField.text
                passwordString = passwordTextField.text
                
                //                userNameTextField.enabled = false
                //                passwordTextField.enabled = false
                
                goToPage()
            }
        }
        
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "menuSegueFromLogin"
        {
            let destinationViewController = segue.destinationViewController as! MEC
            
            var daysAgoInformationWasCurrentInteger: Int! = -1
            
            if PFUser.currentUser()!.updatedAt == NSDate()
            {
                daysAgoInformationWasCurrentInteger = 0
            }
            else
            {
                let currentCalendar: NSCalendar = NSCalendar.currentCalendar()
                
                let lastUpdatedDate = currentCalendar.startOfDayForDate(PFUser.currentUser()!.updatedAt!)
                let currentDate = currentCalendar.startOfDayForDate(NSDate())
                
                let dateFlags = NSCalendarUnit.Day
                let calendarComponents = currentCalendar.components(dateFlags, fromDate: lastUpdatedDate, toDate: currentDate, options: [])
                
                daysAgoInformationWasCurrentInteger = calendarComponents.day
            }
            
            destinationViewController.usernameString = PFUser.currentUser()!.username
            destinationViewController.passwordString = PFUser.currentUser()!.password
            destinationViewController.firstNameString = PFUser.currentUser()!.objectForKey("firstName") as! String
            destinationViewController.lastNameString = PFUser.currentUser()!.objectForKey("lastName") as! String
            destinationViewController.emailString = PFUser.currentUser()!.email
            destinationViewController.daysAgoInformationWasCurrentInteger = daysAgoInformationWasCurrentInteger
            destinationViewController.timesCleanedInteger = PFUser.currentUser()!.objectForKey("timesCleaned") as! Int
            destinationViewController.versionChoice = versionChoice
        }
    }
}

extension String
{
    var noWhiteSpaceLowerCaseString: String { return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString }
}