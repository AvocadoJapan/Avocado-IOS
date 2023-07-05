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

final class ProfileSettingVM {
    
    var selectedImageSubject = BehaviorSubject<UIImage>(value: UIImage(named: "default_profile") ?? UIImage())
    let nickNameInput = BehaviorRelay<String>(value: "")
    let successEvent = PublishRelay<Bool>()
    let errEvent = PublishRelay<NetworkError>()
    let service: AuthService
    let disposeBag = DisposeBag()
    
    init(service:AuthService) {
        self.service = service
    }
    
    func profileSetUp() {
        service.avocadoSignUp(to: nickNameInput.value, with: 1)
            .subscribe(onNext: {
                Logger.d("profile \($0)")
                self.successEvent.accept(true)
            }) { err in
                self.errEvent.accept(err as! NetworkError)
            }
            .disposed(by: disposeBag)
    }
}

