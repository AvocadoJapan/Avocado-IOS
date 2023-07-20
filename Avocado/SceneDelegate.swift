//
//  SceneDelegate.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/02.
//

import UIKit
import RxSwift
import RxFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator = FlowCoordinator()
    let disposeBag = DisposeBag()

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: windowScene)
        
//        let splashFlow = SplashFlow()
//        let letsplashStepper = OneStepper(withSingleStep: SplashStep.tokenIsRequired)
//        
//        let authService = AuthService()
//        // 로그인 여부 판단하여 로그인 활상화 되어있는 유저일 경우 메인화면으로 보냄 {아닐 경우 로그인화면으로 전송}
//        let splashVM = SplashVM(service: authService)
//        let splashVC = SplashVC(viewModel: splashVM)
//        self.window?.rootViewController = splashVC
//        self.window?.makeKeyAndVisible()
        
        guard let windowSecene = (scene as? UIWindowScene) else { return }
        
        let appFlow = SplashFlow() // 흐름
        let appStepper = SplashStepper() // 흐름 트리거
        
        // 흐름 & 흐름 트리거 연결되었음
        self.coordinator.coordinate(flow: appFlow, with: appStepper)
        
        Flows.use(appFlow, when: .created, block: { rootVC in
            let window = UIWindow(windowScene: windowSecene)
            window.rootViewController = rootVC
            self.window = window
            window.makeKeyAndVisible()
        })
        
        
        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)

        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
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
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
            // 소셜 계정 연동 스킴
            if let host = url.host,
               host == "socialSync" {
               
                guard let rootViewController = self.window?.rootViewController else {
                    Logger.d("rootVC Not found")
                    return
                }
                
                rootViewController.dismiss(animated: true) {
                    let alertController = UIAlertController(title: "", message: "소셜 계정이 연동 되었습니다", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .default))
                    rootViewController.present(alertController, animated: true)
                }
            }
        }
    }


}

