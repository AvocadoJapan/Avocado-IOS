//
//  SettingVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/06.
//

import Foundation
import RxSwift
import RxRelay

final class SettingVM {
    
    let service: SettingService
    let disposeBag = DisposeBag()
    
    // 설정 정적 데이터
    let staticSettingData = BehaviorRelay<[SettingDataSection]>(value: [
        SettingDataSection(title: "사용자 지원", items: [
            SettingData(title: "구글 연동하기", imageName: "btn_google", type: .syncSocial(type: .google)),
            SettingData(title: "Apple 연동하기", imageName: "btn_apple", type: .syncSocial(type: .apple)),
            SettingData(title: "사용자 로그아웃", type: .userLogOut),
            SettingData(title: "계정 탈퇴", type: .deleteAccount),
        ])
    ])
    
    // api call 이벤트
    let successEvent = PublishRelay<String>()
    let successLogOutEvent = PublishRelay<Bool>()
    let successDeleteAccountEvent = PublishRelay<Bool>()
    
    init(service: SettingService) {
        self.service = service
    }
    
    func socialSync(type: SocialType) {
        service.socialSync(provider: type, callBack: "avocado://socialSync")
            .subscribe { url in
                self.successEvent.accept(url.url)
            } onError: { err in
                
            }
            .disposed(by: disposeBag)
    }
    
    func userLogOut() {
        service.logout()
            .subscribe(onNext: {
                if $0 {
                    self.successLogOutEvent.accept(true)
                }
            }, onError: { err in
                
            })
            .disposed(by: disposeBag)
    }
    
    func userDeleteAccount() {
        service.deleteAccount()
            .subscribe(onNext: {
                if $0 {
                    self.successDeleteAccountEvent.accept(true)
                }
            }, onError: { err in
                
            })
            .disposed(by: disposeBag)
    }
}
