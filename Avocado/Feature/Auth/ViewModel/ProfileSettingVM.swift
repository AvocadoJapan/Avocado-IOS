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
import RxFlow

final class ProfileSettingVM: ViewModelType, Stepper {
    
    private let s3Service: S3Service // S3Upload 서비스 객체
    private let regionId: String // 활동 지역 정보
    private(set) var input: Input // 사용자 인풋 데이터
    var steps: PublishRelay<Step> = PublishRelay() // RxFlow 처리 Step
    let service: AuthService // API 서비스 객체
    var disposeBag = DisposeBag()
    
    // 사용자 인풋 구조체
    struct Input {
        let selectedImageDataRelay = BehaviorRelay<Data>(value: Data()) // 이미지 데이터
        let nickNameInputRelay = BehaviorRelay<String>(value: "")
        let actionProfileSetUpRelay = PublishRelay<Void>()
    }
    
    // 사용자 인풋을 통한 아웃풋
    struct Output {
        let successSignUpeRelay = PublishRelay<Bool>() // 회원가입 성공 데이터
        let errEventPublish = PublishRelay<UserAuthError>() // 오류 데이터
    }
    
    // regionID가 필요 없는 경우
    init(service: AuthService, s3Service: S3Service) {
        self.service = service
        self.regionId = ""
        self.s3Service = s3Service
        input = Input()
    }
    
    // regionId가 필요한 경우
    init(service:AuthService, regionid: String, s3Service: S3Service) {
        self.service = service
        self.regionId = regionid
        self.s3Service = s3Service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // avocado 회원가입
        input.actionProfileSetUpRelay.flatMap { [weak self] _ in
            // 순환 참조가 일어날 경우를 대비한 guard문, 만약 순환참조가 일어났을 경우 에러 리턴
            guard let self = self else { throw NetworkError.unknown(-1, "유효하지 않은 화면") }
            // API로 presignedURL 요청
            return self.service.uploadAvatar(type: "image/jpeg", size: Int64(input.selectedImageDataRelay.value.count))
        }
        .flatMap { [weak self] data in
            guard let self = self else { throw NetworkError.unknown(-1, "유효하지 않은 화면") }
            // s3Upload 진행
            return self.s3Service.uploadS3(requestURL: data.url, uploadData: input.selectedImageDataRelay.value, parameter: data.fields)
        }
        .flatMap { [weak self] _ in
            guard let self = self else { throw NetworkError.unknown(-1, "유효하지 않은 화면") }
            // 업로드에 성공했을 경우 회원가입 진행
            return self.service.avocadoSignUp(to: input.nickNameInputRelay.value, with: self.regionId)
        }
        .subscribe { user in
            output.successSignUpeRelay.accept(true)
        } onError: { err in
            output.errEventPublish.accept(.unknown(message: err.localizedDescription))
        }
        .disposed(by: disposeBag)
        
        return output
    }
}
