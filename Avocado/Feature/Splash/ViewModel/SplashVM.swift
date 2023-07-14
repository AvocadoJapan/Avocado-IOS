//
//  SplashVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/11.
//

import RxSwift
import RxRelay

final class SplashVM {
    
    let service: AuthService
    let disposeBag = DisposeBag()
    let successEvent = PublishRelay<User>()
    let errEvent = PublishRelay<NetworkError>()
    
    init(service: AuthService) {
        self.service = service
    }
    
    func splashAvocado() {
        service.checkLoginSession()
            .subscribe(onNext: { [weak self] isLogin in
                guard let self = self else { return }
                
                if (isLogin) {
                    
                    self.service.getProfile()
                        .subscribe(onNext: { user in
                            self.successEvent.accept(user)
                        }, onError: { err in
                            
                            guard let err = err as? NetworkError else {
                                self.errEvent.accept(NetworkError.unknown(-1, err.localizedDescription))
                                return
                            }
                            
                            self.errEvent.accept(err)
                        })
                        .disposed(by: self.disposeBag)
                }
                else {
                    // 로그인이 되어있지 않을때 이부분이 탐
                    self.errEvent.accept(NetworkError.unknown(-10, "사용자 로그인이 되지않음"))
//                    self.errEvent.accept(NetworkError.unknown(-20, "성공적인 에러 테스트입니다."))
                }
            }, onError: { err in
                Logger.e(err.localizedDescription)
                self.errEvent.accept(NetworkError.unknown(-20, err.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
}
