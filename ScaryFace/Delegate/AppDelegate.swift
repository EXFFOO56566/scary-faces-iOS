//
//  AppDelegate.swift
//  ScaryFace
//
//  Created by Apps4World on 9/12/20.
//  Copyright © 2020 Apps4World. All rights reserved.
//

import UIKit
import Apps4World
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ScaryFacesManager.configure(purchaseCode: "CodeCanyon_Item_Purchase_Code")
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

