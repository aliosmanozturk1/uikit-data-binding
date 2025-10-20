//
//  MainTabBarController.swift
//  DataBinding
//
//  Created by Ali Osman Öztürk on 5.10.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers: [(UIViewController, String, String)] = [
            (ViewControllerClosure(), "Closure", "1.circle"),
            (ViewControllerDelegate(), "Delegate", "2.circle"),
            (ViewControllerNotification(), "Notification", "3.circle"),
            (ViewControllerCombine(), "Combine", "4.circle"),
            (ViewControllerRxSwift(), "RxSwift", "5.circle")
        ]
        
        viewControllers = controllers.enumerated().map { index, item in
            let navController = UINavigationController(rootViewController: item.0)
            navController.tabBarItem = UITabBarItem(
                title: item.1,
                image: UIImage(systemName: item.2),
                tag: index
            )
            return navController
        }
    }
}
