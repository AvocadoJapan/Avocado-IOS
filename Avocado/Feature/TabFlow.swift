//
//  TabFlow.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/31.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxRelay
import RxCocoa
import Then

final class TabFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    var rootViewController = BaseTabBarController()
    
    init() {
        
        Logger.i("TabFlow init")
//        self.rootViewController.delegate = self
    }
    
    deinit {
        Logger.i("TabFlow deinit")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? TabStep else { return .none }
        
        switch step {
            
        case .mainTabIsRequired:
            return navigateToMain()
        }
    }
    
//    // UITabBarControllerDelegate 메서드
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController.title == TabType.upload.title {
//            // Upload 화면을 present합니다.
//            presentToUploadScreen()
//            return false  // 실제로 탭을 전환하지 않습니다.
//        }
//        return true  // 그 외의 탭은 정상적으로 전환합니다.
//    }
//    
//    private func presentToUploadScreen() {
//    }
    
    /**
     * - description 메인탭으로 이동
     */
    private func navigateToMain(focusedTab: TabType = .home) -> FlowContributors {
        let mainFlow = MainFlow(root: BaseNavigationVC())
        let uploadFlow = UploadFlow(root: BaseNavigationVC())
        let settingFlow = SettingFlow(root: BaseNavigationVC())

        Flows.use(mainFlow, uploadFlow, settingFlow, when: .created) { [unowned self] (home: UINavigationController, upload: UINavigationController, myPage: UINavigationController) in
            
            home.tabBarItem = TabType.home.tabBarItem
            home.title = TabType.home.title
            upload.tabBarItem = TabType.upload.tabBarItem
            upload.title = TabType.upload.title
            myPage.tabBarItem = TabType.myPage.tabBarItem
            myPage.title = TabType.myPage.title
            


            self.rootViewController.setViewControllers([home, upload, myPage], animated: false)
            self.rootViewController.selectedIndex = focusedTab.rawValue
            
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: mainFlow, withNextStepper: OneStepper(withSingleStep: MainStep.mainIsRequired)),
            .contribute(withNextPresentable: uploadFlow, withNextStepper: OneStepper(withSingleStep: UploadStep.uploadIsRequired)),
            .contribute(withNextPresentable: settingFlow, withNextStepper: OneStepper(withSingleStep: SettingStep.settingIsComplete)),
        ])
    }
    
    // FIXME: 작동하도록 수정해야됨
    /**
     * - description 에러화면 이동 플로우 함수 // 현재 작동하지않음
     */
    private func errorTrigger(error: NetworkError) -> FlowContributors {
        let splashFlow = SplashFlow()
        
        Flows.use(splashFlow, when: .created) { [unowned self] root in
            self.rootViewController = root as! UITabBarController as! BaseTabBarController
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: splashFlow, withNextStepper: OneStepper(withSingleStep: SplashStep.errorOccurred(error: error))))
    }
}
