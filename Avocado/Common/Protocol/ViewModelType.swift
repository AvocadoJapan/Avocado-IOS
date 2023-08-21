//
//  ViewModelType.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/16.
//

import RxSwift

// RxFlow를 강제하는 프로토콜이 아니기 때문에 ViewModelType에는 RxFlow관련 내용을 넣지 않음.
/**
 * - Description ViewModel Base 프로토콜
 *
 * **associatedtype**
 *
 * `Input`: 사용자 입력에 대한 데이터
 *
 * `Output`: 결과 화면에 보여주는 완성형 데이터 (ex. Observable.. Driver)
 *
 * `Service`: API에 접근할 서비스 객체 정보
 *
 * `transform`: 사용자 Input 데이터를 전달받아 Output 데이터로 반환해주는 함수 (비즈니스 로직 처리)
 *
 * ```
 * func transform(input: Input) -> Output {
 *  input.test.subscribe(onNext: {
 *     //do Someting...
 *  })
 *  .dispose(disposebag)
 * }
 * ```
 */
protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    associatedtype Service
    
    var service: Service {get}
    var disposeBag: DisposeBag {get set}
    
    func transform(input: Input) -> Output
}
