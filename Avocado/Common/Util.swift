//
//  Util.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/12.
//

import UIKit

/**
 * - Description 공통 유틸클래스
 */
final class Util {
//    static func makeTabBarViewController() -> UITabBarController {
//        let service = SettingService()
//        let settingVM = SettingVM(service: service)
//        let settingVC = SettingVC(vm: settingVM)
//        let settingNavigationVC = settingVC.makeBaseNavigationController()
//        settingNavigationVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person.fill"), tag: 1)
//        
//        let service = MainService()
//        let mainVM = MainVM(service: service, user: nil)
//        let mainVC = MainVC(viewModel: mainVM)
//        let mainNavigationVC = mainVC.makeBaseNavigationController()
//        mainNavigationVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house.fill"), tag: 1)
//        
//        let tabbarController = UITabBarController()
//        
//        tabbarController.viewControllers = [
//            mainNavigationVC,
//            settingNavigationVC
//        ]
//        
//        tabbarController.selectedViewController = mainNavigationVC
//        tabbarController.tabBar.tintColor = .black
//        
//        return tabbarController
//    }
    
    static func changeRootViewController(to changeViewController: UIViewController) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            Logger.e("SceneDelegate or Window is nil !")
            return
        }
        
        window.rootViewController = changeViewController
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil)
    }
}
