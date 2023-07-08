//
//  SceneDelegate.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/02.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let authService = AuthService()
        // 로그인 여부 판단하여 로그인 활상화 되어있는 유저일 경우 메인화면으로 보냄 {아닐 경우 로그인화면으로 전송}
        authService.checkLoginSession()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLogin in
                if (isLogin) {
                    let mainViewModel = MainVM()
                    let mainVC = MainVC(vm: mainViewModel)
                    
                    let regionSettingVC = RegionSettingVC(vm: RegionSettingVM())
                    
                    self?.window?.rootViewController = regionSettingVC
                    self?.window?.makeKeyAndVisible()
                }
                else {
                    // 새션이 종료된 경우 로그인 토큰 삭제
                    KeychainUtil.loginTokenDelete()
                    
                    let signUpViewModel = WelcomeVM(service: authService)
                    let signUpVC = WelcomeVC(vm: signUpViewModel)
                    let baseNavigationController = signUpVC.getBaseNavigationController()
                    
                    self?.window?.rootViewController = baseNavigationController
                    self?.window?.makeKeyAndVisible()
                }
            })
            .disposed(by: disposeBag)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

