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
    
    init(viewModel: SplashVM) {
        self.viewModel = viewModel
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
        viewModel.successEventPublish
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { user in
                let tabbarViewController = Util.makeTabBarViewController()
                Util.changeRootViewController(to: tabbarViewController)
            })
            .disposed(by: disposeBag)
        
        viewModel.errEventPublish
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                switch error {
                case .unknown(let code, _):
                    if code == -20 {
                        let failVC = FailVC(error: error)
                        let baseNavigationController = failVC.makeBaseNavigationController()
                        Util.changeRootViewController(to: baseNavigationController)
                    } else {
                        let service = AuthService()
                        let signUpViewModel = WelcomeVM(service: service)
                        let signUpVC = WelcomeVC(viewModel: signUpViewModel)
                        let baseNavigationController = signUpVC.makeBaseNavigationController()
                        Util.changeRootViewController(to: baseNavigationController)
                    }
                default:
                    let service = AuthService()
                    let signUpViewModel = WelcomeVM(service: service)
                    let signUpVC = WelcomeVC(viewModel: signUpViewModel)
                    let baseNavigationController = signUpVC.makeBaseNavigationController()
                    Util.changeRootViewController(to: baseNavigationController)
                }
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SplashVCPreview: PreviewProvider {
    static var previews: some View {
        return SplashVC(viewModel: SplashVM(service: AuthService())).toPreview().ignoresSafeArea()
    }
}
#endif
