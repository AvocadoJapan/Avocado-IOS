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
    let nickNameInputRelay = BehaviorRelay<String>(value: "")
    let successEventPublish = PublishRelay<Bool>()
    let errEventPublish = PublishRelay<NetworkError>()
    let authService: AuthService
    let disposeBag = DisposeBag()
    let regionId: String
    
    init(service:AuthService, regionid: String) {
        self.authService = service
        self.regionId = regionid
    }
    
    func profileSetUp() {
        authService.avocadoSignUp(to: nickNameInputRelay.value, with: regionId)
            .subscribe(onNext: {
                Logger.d("profile \($0)")
                self.successEventPublish.accept(true)
            }) { err in
                self.errEventPublish.accept(err as! NetworkError)
            }
            .disposed(by: disposeBag)
    }
    
    func changeAvatar() {
        
    }
}
