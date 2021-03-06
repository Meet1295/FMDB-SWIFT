//
//  AppDelegate.swift
//  MyApp
//
//  Created by Ankur on 25/06/18.
//  Copyright © 2018 Olynk Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import IQKeyboardManagerSwift
import Reachability
import FMDB
import CoreLocation

//Firebase table Name
let kTblUsers           = "users"
let kTblScannedUsers    = "scannedUsers"

//User table Constant
let kDisplayName     = "displayName"
let kEmail           = "email"
let kFirstName       = "firstName"
let kLastName        = "lastName"
let kPhotoUrl        = "photoUrl"

let kserverTimestamp        = "serverTimestamp"
let kUserId                 = "userId"

let kIsFromFirebase = "isFromFirebase"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    var ble: BLEPeripheralManager?
    var bleCentralManager: BLECentralManager?
    var fmdbManager : fmdbClass?
    var latitude = Double()
    var longitude = Double()
    let manager = CLLocationManager()
    var location = CLLocation()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ble = BLEPeripheralManager()
        ble?.startBLEPeripheral()
        
        UIApplication.shared.isIdleTimerDisabled = true
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        SetInitializePoint()
        return true
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//
//        let message = url.host?.removingPercentEncoding
//        let alertController = UIAlertController(title: "Incoming Message", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
//        alertController.addAction(okAction)
//
//        window?.rootViewController?.present(alertController, animated: true, completion: nil)
//        return true
//    }   
    
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    //MARK:- Initialize Methods -
    //
    func SetInitializePoint() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let UID =  UserDefaults.standard.value(forKey: USER_ID_KEY) as? String
        if UID == nil {
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "navCont")
           self.window?.rootViewController = initialViewController
        }
        else {
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "navHome")
            self.window?.rootViewController = initialViewController
        }
    
        
        self.window?.makeKeyAndVisible()
    }    
    
    //MARK:-  GET LOCATION PERMISSION -
    func getLocationPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }else if CLLocationManager.authorizationStatus() == .denied{
            let alert = UIAlertController(title: "Need Authorization", message: "This app is needs authorize to use your location!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }))
            if let app = UIApplication.shared.delegate as? AppDelegate, let keyWindow = app.window{
                keyWindow.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }else{
            manager.startUpdatingLocation()
        }
        manager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
        manager.stopUpdatingLocation()
    }
 
}

