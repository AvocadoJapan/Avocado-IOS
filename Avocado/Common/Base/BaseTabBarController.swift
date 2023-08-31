//
//  BaseTabBarController.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/31.
//

import Foundation
import UIKit

/**
 * - description 커스텀 탭바
 */
final class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .black
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = .systemGray
//        self.tabBar.standardAppearance
        
        tabBar.layer.shadowColor = UIColor.systemGray6.cgColor
        tabBar.layer.shadowRadius = 10
    }
}
