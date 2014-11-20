//
//  AppDelegate.swift
//  Rendezvous
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Setting up Parse
        Parse.setApplicationId("Hgj3JBmV3Ep9HzJDK8wC6mCDu6pqrkABrf45Jwh9", clientKey: "N2Y9Iv2PScKzt1QAWIv9Gy48Jk3eNNn98rGKCawj")
        PFFacebookUtils.initializeFacebook()
        
        
        //Set up Push Notifications
        var types: UIUserNotificationType = UIUserNotificationType.Badge |
            UIUserNotificationType.Alert |
            UIUserNotificationType.Sound
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        
        //set up for Google Maps API
        
        GMSServices.provideAPIKey("AIzaSyBodzRxtGixKP-Ox9Ut9_KLG6EX0kmy5vo")
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        println(storyboard.description)
        var initialViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        
        var currentUser = PFUser.currentUser()
        if (currentUser != nil && PFFacebookUtils.isLinkedWithUser(currentUser)) {
            initialViewController = storyboard.instantiateViewControllerWithIdentifier("ContainerViewController") as UIViewController
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        
        PFPush.storeDeviceToken(deviceToken)
        PFPush.subscribeToChannelInBackground("")
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError){
        NSLog("Failed to register for push, %@", error)
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String,
        annotation: AnyObject?) -> Bool {
            return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
                withSession:PFFacebookUtils.session())
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

