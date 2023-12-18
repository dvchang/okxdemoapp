//
//  AppDelegate.swift
//  okxdemo
//
//  Created by David Chang on 12/18/23.
//

import UIKit
import OKXUIlib
import Alamofire
import OKXModellib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
            
        let viewController = OKXUIlib.HomeViewController()
        
        let fetcher = OKXModellib.OKXDataFetcher()
        
        fetcher.fetchData { dataArray, error in
            if (dataArray != nil) {
                var rawData : [(String, String)] = []
                for data in dataArray! {
                    rawData.append((data.imageURL, data.videoURL))
                }
                viewController.showData(rawData: rawData)
            }
        }
        
        window?.rootViewController = viewController
            
        window?.makeKeyAndVisible()
        
        return true
    }


}

