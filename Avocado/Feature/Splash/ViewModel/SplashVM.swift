//
//  SplashVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/11.
//

import RxSwift
import RxRelay
import RxFlow
import RxCocoa
import Foundation

final class SplashVM: Stepper {
    
    // Service 인스턴스
    let authService: AuthService
    
    //MARK: - RXFlow
    var steps: PublishRelay<Step> = PublishRelay()
    
    //MARK: - RX
    // 에러 이벤트를 전달하는 인스턴스 <User>
    let successEventPublish = PublishRelay<User>()
    // 에러 이벤트를 전달하는 인스턴스
    let errEventPublish = PublishRelay<NetworkError>()
    let disposeBag = DisposeBag()
    
    // Private
    private var isCheckingSession = false
    
    init(service: AuthService) {
        self.authService = service
        
        bindRxFlow()
    }
    
    func checkLoginSession() {
        authService.checkLoginSession()
            .subscribe(onNext: { [weak self] isLogin in
                guard let self = self else { return }
                
                if isLogin {
                    self.getProfile()
                } else {
                    self.errEventPublish.accept(NetworkError.tokenIsRequired)
                }
            }, onError: { error in
                if let networkError = error as? NetworkError {
                    self.errEventPublish.accept(networkError)
                } else {
                    self.errEventPublish.accept(NetworkError.unknown(-1, error.localizedDescription))
                }
            })
            .disposed(by: disposeBag)
    }


    private func getProfile() {
        authService.getProfile()
            .subscribe(onNext: { [weak self] user in
                self?.successEventPublish.accept(user)
            }, onError: { error in
                if let networkError = error as? NetworkError {
                    self.errEventPublish.accept(networkError)
                } else {
                    self.errEventPublish.accept(NetworkError.unknown(-1, error.localizedDescription))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindRxFlow() {
        successEventPublish
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                self?.steps.accept(SplashStep.tokenIsExist(user: user))
//                self?.steps.accept(SplashStep.errorOccurred(error: NetworkError.unknown(500, "Unknown Error")))
            })
            .disposed(by: disposeBag)
        
        errEventPublish
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                switch error {
                case .invalidResponse, .invalidURL, .pageNotFound, .serverConflict, .serverError:
                    self?.steps.accept(SplashStep.errorOccurred(error: error))
                case .tokenExpired:
                    self?.steps.accept(SplashStep.tokenIsRequired)
                case .tokenIsRequired:
                    self?.steps.accept(SplashStep.tokenIsRequired)
                case .unknown:
                    self?.steps.accept(SplashStep.errorOccurred(error: error))
                }
            })
            .disposed(by: disposeBag)
    }
}
