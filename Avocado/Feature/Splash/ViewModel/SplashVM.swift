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

final class SplashVM {
    
    let authService: AuthService
    let disposeBag = DisposeBag()
    let successEventPublish = PublishRelay<User>()
    let errEventPublish = PublishRelay<NetworkError>()
    
    private var isCheckingSession = false
    
    init(service: AuthService) {
        self.authService = service
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
}
