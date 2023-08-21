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
            .flatMap { [weak self] isLogin -> Observable<User> in
                guard let self = self else { throw NetworkError.unknown(-1, "유효하지 않은 화면입니다") }
                
                // 로그인이 되지 않은 경우 welcome 페이지로 이동
                guard isLogin else {
                    
                    // 시용자가 이메일인증을 받지 않고 종료한 경우, 유저 삭제 진행
                    if let notConfirmedUserID = UserDefaults.standard.string(forKey: UserDefaultsKey.Auth.notConfirmedUserID) {
                        // 사용자 삭제 후 welcome 페이지 이동
                        return self.authService.adminDeleteUserAccount(userId: notConfirmedUserID).map { throw NetworkError.tokenExpired }
                    }
                    else {
                        throw NetworkError.tokenIsRequired
                    }
                }
                
                // avocado 서버 프로필 조회
                return self.authService.getProfile()
            }
            .catch { [weak self] err in
                
                guard let networkError = err as? NetworkError else {
                    let error = err as! UserAuthError
                    self?.errEventPublish.accept(NetworkError.unknown(-1, error.errorDescription))
                    return Observable.empty()
                }
                
                guard let self = self else {
                    self?.errEventPublish.accept(NetworkError.unknown(-1, "유효하지 않은 화면입니다"))
                    return Observable.empty()
                }
                
                /*
                 Response 응답값이 404인 경우 avocado에서 사용자를 만들지 않은 경우이기 때문에 사용자 삭제 후 welcome페이지로 이동
                 그 외인 경우 에러값 설정 후 스트림 종료
                 */
                switch networkError {
                case .pageNotFound:
                    
                    // 사용자 삭제 후 스트림 종료
                    return self.authService.deleteAccount()
                        .map { _ in self.errEventPublish.accept(NetworkError.tokenIsRequired) }
                        .flatMap { _ in return Observable.empty() }
                    
                default:
                    self.errEventPublish.accept(networkError)
                    return Observable.empty()
                }
            }
            .bind(to: successEventPublish)
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
