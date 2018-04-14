/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains the application's delegate.
*/

import UIKit
import ARKit
import AWSMobileClient


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        if !ARFaceTrackingConfiguration.isSupported {
            /*
             Shipping apps cannot require a face-tracking-compatible device, and thus must
             offer face tracking AR as a secondary feature. In a shipping app, use the
             `isSupported` property to determine whether to offer face tracking AR features.
             This sample code has no features other than a demo of ARKit face tracking, so
             it replaces the AR view (the initial storyboard in the view controller) with
             an alternate view controller containing a static error message.
             */
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "unsupportedDeviceMessage")
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USWest2, identityPoolId: "us-west-2:5abf65c2-8d84-487b-95c8-60c4cd11c869")
        let configuration = AWSServiceConfiguration(region: .USWest1, credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        // Create AWSMobileClient to connect with AWS
        return AWSMobileClient.sharedInstance().interceptApplication(
            application,
            didFinishLaunchingWithOptions: launchOptions)
    }
}
