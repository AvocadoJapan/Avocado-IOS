//
//  UploadVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/30.
//

import Foundation
import RxRelay
import RxSwift
import RxFlow
import Amplify
import UIKit

final class UploadVM: ViewModelType {
    //MARK: - RXFlow
    var steps: PublishRelay<Step> = PublishRelay()
    
    // 서비스를 제공하는 인스턴스
    let service: UploadService
    var disposeBag = DisposeBag()
    private(set) var input: Input
    
    struct Input {
        // 업로드 버튼 액션
        let actionOtherEmailSignUpRelay = PublishRelay<Void>()
    }
    
    struct Output {
        // 사진을 입력받는 인스턴스
        let imageRelay = BehaviorRelay<[UIImage]>(value: [])
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<AvocadoError>()
    }
    
    // 생성자
    init(service: UploadService) {
        self.service = service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
