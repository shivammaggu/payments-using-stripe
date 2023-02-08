//
//  AppDelegate.swift
//  payments with stripe
//
//  Created by Shivam Maggu on 30/01/23.
//

import UIKit
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: ICoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        // Set UINavigationController as the initial view controller for the application
        
        let controller = UINavigationController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
        
        // Set the app navigation for navigating to other ViewControllers
        
        self.appCoordinator = AppCoordinator(rootViewController: controller)
        self.appCoordinator?.start()
        
        // Stripe Publishable key for Testing
        // TODO: Add condition to switch between test mode and live mode keys based on environment (Dev/Staging/Testing and Production)
        
        StripeAPI.defaultPublishableKey = "Insert your publishable key here"
        
        return true
    }
    
    // This method handles opening custom URL schemes
    // (for example, "your-app://stripe-redirect")
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let stripeHandled = StripeAPI.handleURLCallback(with: url)
        
        if !stripeHandled {
            
            /*
             This was not a stripe url, do whatever url handling your app
             normally does, if any.
             */
        }
        
        return true
    }
    
    // This method handles opening universal link URLs
    // (for example, "https://example.com/stripe_ios_callback")
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool  {
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            
            if let url = userActivity.webpageURL {
                
                let stripeHandled = StripeAPI.handleURLCallback(with: url)
                
                guard !stripeHandled else { return true }
                
                /*
                 This was not a stripe url, do whatever url handling your app
                 normally does, if any.
                 */
            }
        }
        
        return false
    }
}
