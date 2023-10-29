//
//  ProfileVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/10/09.
//

import Foundation
import RxSwift
import RxRelay
import RxFlow

final class ProfileVM: ViewModelType {
    let service: AuthService
    var disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    private(set) var input: Input
    
    struct Input {
        let actionViewDidLoad = PublishRelay<Void>()
        let actionSocialSync = PublishRelay<SocialType>()
        let actionUserLogout = PublishRelay<Void>()
        let actionUserDeleteAccount = PublishRelay<Void>()
    }
    
    struct Output {
        let successDeleteAccountEvent = PublishRelay<Void>()
        let successSocialSyncEvent = PublishRelay<String>()
        let successLogOutEvent = PublishRelay<Void>()
        
        let staticSettingData = BehaviorRelay<[SettingDataSection]>(value: [
            SettingDataSection(title: "소셜 연동하기", items: [
                SettingData(
                    title: "구글 연동하기",
                    imageName: "btn_google",
                    type: .syncSocial(type: .google)
                ),
                SettingData(
                    title: "Apple 연동하기",
                    imageName: "btn_apple",
                    type: .syncSocial(type: .apple)
                )
            ]),
            SettingDataSection(title: "사용자 지원", items: [
                SettingData(
                    title: "사용자 로그아웃",
                    type: .userLogOut
                ),
                SettingData(
                    title: "계정 탈퇴",
                    type: .deleteAccount
                )
            ])
        ])
        
        let errorEventPublish = PublishRelay<AvocadoError>()
        
    }
    
    init(service: AuthService) {
        self.service = service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // 소셜 연동
        input.actionSocialSync
            .flatMap { [weak self] type in
                return self?.service.socialSync(
                    provider: type,
                    callBack: "avocado://socialSync"
                )
                .catch {
                    guard let avocadoError = $0 as? AvocadoError else {
                        return .empty()
                    }
                    
                    output.errorEventPublish.accept(avocadoError)
                    return .empty()
                } ?? .empty()
            }
            .subscribe(onNext: { response in
                output.successSocialSyncEvent.accept(response.url)
            })
            .disposed(by: disposeBag)
        
        // 계정 삭제
        input.actionUserDeleteAccount
            .flatMap { [weak self] in
                return self?.service.deleteAccount()
                    .catch {
                        guard let avocadoError = $0 as? AvocadoError else {
                            return .empty()
                        }
                        
                        output.errorEventPublish.accept(avocadoError)
                        return .empty()
                    } ?? .empty()
            }
            .subscribe(onNext: { _ in
                output.successDeleteAccountEvent.accept(())
            })
            .disposed(by: disposeBag)
        
        // 사용자 로그아웃
        input.actionUserLogout
            .flatMap { [weak self] in
                return self?.service.logout()
                    .catch {
                        guard let avocadoError = $0 as? AvocadoError else {
                            return .empty()
                        }
                        
                        output.errorEventPublish.accept(avocadoError)
                        return .empty()
                    } ?? .empty()
            }
            .subscribe(onNext: {
                output.successLogOutEvent.accept(())
            })
            .disposed(by: disposeBag)
        
        
        return output
    }
}
