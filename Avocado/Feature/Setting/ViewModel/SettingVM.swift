//
//  SettingVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/06.
//

import Foundation
import RxSwift
import RxRelay
import RxFlow

final class SettingVM: ViewModelType {
    
    // 사용자 입력 정보
    struct Input {
        let actionSocialSync = PublishRelay<SocialType>()
        let actionUserDeleteAccount = PublishRelay<Void>()
        let actionUserLogout = PublishRelay<Void>()
    }
    
    // View Binding에 사용될 출력 정보
    struct Output {
        let successSocialSyncEvent = PublishRelay<String>()
        let successLogOutEvent = PublishRelay<Bool>()
        let successDeleteAccountEvent = PublishRelay<Bool>()
        let staticSettingData = BehaviorRelay<[SettingDataSection]>(value: [
            SettingDataSection(title: "사용자 지원", items: [
                SettingData(title: "구글 연동하기", imageName: "btn_google", type: .syncSocial(type: .google)),
                SettingData(title: "Apple 연동하기", imageName: "btn_apple", type: .syncSocial(type: .apple)),
                SettingData(title: "사용자 로그아웃", type: .userLogOut),
                SettingData(title: "계정 탈퇴", type: .deleteAccount),
            ])
        ])
    }
        
    let service: SettingService
    var disposeBag = DisposeBag()
    let steps: PublishRelay<Step> = PublishRelay()
    private(set) var input: Input // 내부에서는 get,set 외부에서는 read-only
    
    init(service: SettingService) {
        self.service = service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // 소셜 연동
        input.actionSocialSync
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                self.service.socialSync(provider: type, callBack: "avocado://socialSync")
                    .subscribe(onNext: { url in
                        output.successSocialSyncEvent.accept(url.url)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        // 로그아웃
        input.actionUserLogout
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.service.logout()
                    .subscribe(onNext: { isSuccess in
                        if isSuccess {
                            output.successLogOutEvent.accept(true)
                        }
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        // 계정 삭제
        input.actionUserDeleteAccount
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.service.deleteAccount()
                    .subscribe(onNext: { isSuccess in
                        if isSuccess {
                            output.successDeleteAccountEvent.accept(true)
                        }
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
