//
//  ProfileSettingVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/04.
//

import Foundation
import UIKit
import RxSwift
import Amplify
import RxRelay
import PhotosUI

final class ProfileSettingVM:ViewModelType {
    
    let service: AuthService
    var disposeBag = DisposeBag()
    let regionId: String
    private(set) var input: Input
    
    struct Input {
        var selectedImageSubject = BehaviorSubject<UIImage>(value: UIImage(named: "default_profile") ?? UIImage())
        let nickNameInputRelay = BehaviorRelay<String>(value: "")
        let actionProfileSetUpRelay = PublishRelay<Void>()
    }
    
    struct Output {
        let successSignUpeRelay = PublishRelay<Bool>()
        let successImageRelay = PublishRelay<Bool>()
        let errEventPublish = PublishRelay<UserAuthError>()
    }
    
    // regionID가 필요 없는 경우
    init(service: AuthService) {
        self.service = service
        self.regionId = ""
        input = Input()
    }
    
    // regionId가 필요한 경우
    init(service:AuthService, regionid: String) {
        self.service = service
        self.regionId = regionid
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // avocado 회원가입
        input.actionProfileSetUpRelay.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            service.avocadoSignUp(to: input.nickNameInputRelay.value, with: self.regionId)
                .subscribe(onNext: { _ in
                    output.successSignUpeRelay.accept(true)
                }, onError: { err in
                    output.errEventPublish.accept(err as! UserAuthError)
                })
                .disposed(by: disposeBag)
        })
        .disposed(by: disposeBag)
        
        return output
    }
}
