//
//  SplashVC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/11.
//

import Foundation
import UIKit

final class SplashVC: BaseVC {
    
    lazy var splashImageView = UIImageView().then {
        $0.image = UIImage(named: "default_avocado")
    }
    
    let viewModel: SplashVM
    
    init(vm: SplashVM) {
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // View가 화면에 보여 진 후 API 실행
        viewModel.splashAvocado()
    }
    
    override func setProperty() {
        view.backgroundColor = UIColor(hexCode: "085E05")
    }
    
    override func setLayout() {
        view.addSubview(splashImageView)
    }
    
    override func setConstraint() {
        splashImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.size.equalTo(150)
        }
    }
    
    override func bindUI() {
        viewModel.successEvent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { user in
//                let mainViewModel = MainVM()
//                let mainVC = MainVC(vm: mainViewModel)
//                let regionSettingVC = RegionSettingVC(vm: RegionSettingVM(service: authService))
//                let settingVC = SettingVC(vm: SettingVM(service: SettingService()))
                let tabbarviewController = Util.makeTabBarViewController()
                Util.changeRootViewController(to: tabbarviewController)
            })
            .disposed(by: disposeBag)
        
        //FIXME: 에러 관련하여 좀더 자세하게 수정할 필요가 있음
        viewModel.errEvent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let service = AuthService()
                let signUpViewModel = WelcomeVM(service: service)
                let signUpVC = WelcomeVC(vm: signUpViewModel)
                let baseNavigationController = signUpVC.makeBaseNavigationController()
                Util.changeRootViewController(to: baseNavigationController)
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SplashVCPreview: PreviewProvider {
    static var previews: some View {
        return SplashVC(vm: SplashVM(service: AuthService())).toPreview().ignoresSafeArea()
    }
}
#endif
