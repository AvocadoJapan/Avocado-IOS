//
//  SettingVM.swift
//  Avocado
//
//  Created by FOCUSONE Inc. on 2023/07/06.
//

import Foundation
import RxSwift
import RxRelay

final class SettingVM {
    let service: SettingService
    let disposeBag = DisposeBag()
    let successEvent = PublishRelay<String>()
    init(service: SettingService) {
        self.service = service
    }
    
    func googleSync() {
        service.socialSync(provider: "Google", callBack: "avocado://auth")
            .subscribe(onNext: { url in
                self.successEvent.accept(url.url)
            }, onError: { err in
                
            })
            .disposed(by: disposeBag)
            
    }
}
