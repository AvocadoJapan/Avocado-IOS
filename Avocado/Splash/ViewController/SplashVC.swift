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
    let disposeBag = DisposeBag()
    
    init(vm: SplashVM) {
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            .subscribe(onNext: { [weak self] user in
                let mainViewModel = MainVM()
                let mainVC = MainVC(vm: mainViewModel)
                let mainNavigationVC = mainVC.getBaseNavigationController()
                
//                let regionSettingVC = RegionSettingVC(vm: RegionSettingVM(service: authService))
//                let settingVC = SettingVC(vm: SettingVM(service: SettingService()))
                mainNavigationVC.modalTransitionStyle = .crossDissolve
                self?.present(mainNavigationVC, animated: false)
            })
            .disposed(by: disposeBag)
        
        //FIXME: 에러 관련하여 좀더 자세하게 수정할 필요가 있음
        viewModel.errEvent
            .subscribe(onNext: { [weak self] err in
                let service = AuthService()
                let signUpViewModel = WelcomeVM(service: service)
                let signUpVC = WelcomeVC(vm: signUpViewModel)
                let baseNavigationController = signUpVC.getBaseNavigationController()
                baseNavigationController.modalTransitionStyle = .crossDissolve
                self?.present(baseNavigationController, animated: true)
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
