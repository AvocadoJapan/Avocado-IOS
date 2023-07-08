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
            SettingData(title: "구글 연동하기", imageName: "btn_google"),
            SettingData(title: "Apple 연동하기", imageName: "btn_apple"),
            SettingData(title: "사용자 로그아웃"),
        ])
    ])
    
    // api call 이벤트
    let successEvent = PublishRelay<String>()
    
    init(service: SettingService) {
        self.service = service
    }
    
    func googleSync() {
        service.socialSync(provider: .google, callBack: "avocado://auth")
            .subscribe(onNext: { url in
                self.successEvent.accept(url.url)
            }, onError: { err in
                
            })
            .disposed(by: disposeBag)
    }
    
    func appleSync() {
        service.socialSync(provider: .apple, callBack: "avocado://auth")
            .subscribe { url in
                self.successEvent.accept(url.url)
            } onError: { err in
                
            }
            .disposed(by: disposeBag)
    }
}
