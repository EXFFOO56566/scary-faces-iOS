//
//  AppConfig.swift
//  ScaryFace
//
//  Created by Apps4World on 9/14/20.
//  Copyright © 2020 Apps4World. All rights reserved.
//

import Foundation

/// Basic app configurations
class AppConfig: NSObject {

    /// This is the AdMob Interstitial ad id
    static let adMobAdID: String = "ca-app-pub-7597138854328701/5921460921"
    
    /// Show ads after a certain interval. Currenly set to `4` (after 4 selected scary faces)
    static let adsInterval: Int = 4
}
