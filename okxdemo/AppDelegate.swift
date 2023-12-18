//
//  AppDelegate.swift
//  okxdemo
//
//  Created by David Chang on 12/18/23.
//

import UIKit
import OKXUIlib
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
            
        let viewController = OKXUIlib.HomeViewController()
        
        let url = "https://private-04a55-videoplayer1.apiary-mock.com/pictures"

        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate() // Optional: Validate the status code and content type
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [[String : Any]] {
                        var dataArray : [(String, String)] = []
                        for dataEntry in json {
                            if let imageURL = dataEntry["imageUrl"] as? String, let videoURL = dataEntry["videoUrl"] as? String {
                                dataArray.append((imageURL, videoURL))
                            }
                        }
                        viewController.showData(rawData: dataArray)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        
        window?.rootViewController = viewController
            
        window?.makeKeyAndVisible()
        
        return true
    }


}

