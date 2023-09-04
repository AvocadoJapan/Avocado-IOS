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
import PhotosUI

final class UploadVM: ViewModelType {
    //MARK: - RXFlow
    var steps: PublishRelay<Step> = PublishRelay()
    
    // 서비스를 제공하는 인스턴스
    let service: UploadService
    var disposeBag = DisposeBag()
    private(set) var input: Input
    
    struct Input {
        // 사진을 입력받는 인스턴스
        let imageRelay = BehaviorRelay<[PHPickerResult]>(value: [])
        // 특정 번째 사진을 삭제할때 사용하는 인스턴스
        let removeImageAtIndexRelay = PublishRelay<Int>()
        // 업로드 버튼 액션
        let actionOtherEmailSignUpRelay = PublishRelay<Void>()
    }
    
    struct Output {
        // 사진을 전달하는 인스턴스
        let imageRelay = BehaviorRelay<[ImageDataSection]>(value: [ImageDataSection(imageOrderNum: nil, items: [])])
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
        
        input.imageRelay
            .flatMap { pickerResults in
                Logger.d("\(pickerResults)")
                return self.convertPickerResultsToUIImages(pickerResults)
            }
            .subscribe(onNext: { newImages in
                
                var currentImages: [UIImage] = output.imageRelay.value.first?.items ?? []
                
                // 새로운 이미지를 추가
                currentImages.append(contentsOf: newImages)
                
                // 새로운 ImageDataSection을 생성
                let newImageDataSection = ImageDataSection(imageOrderNum: nil, items: currentImages)
                
                // BehaviorRelay에 업데이트된 배열을 저장
                output.imageRelay.accept([newImageDataSection])
            })
            .disposed(by: disposeBag)
        
        input.removeImageAtIndexRelay
            .subscribe(onNext: { index in
                
                Logger.d("removeImageAtIndex \(index)")
                
                    var currentImages: [UIImage] = output.imageRelay.value.first?.items ?? []
                    // 여기서 이미지를 삭제하는 로직
                    currentImages.remove(at: index)
                
                    // 새로운 ImageDataSection을 생성
                    let newImageDataSection = ImageDataSection(imageOrderNum: nil, items: currentImages)
                    
                    // BehaviorRelay에 업데이트된 배열을 저장
                    output.imageRelay.accept([newImageDataSection])
                }).disposed(by: disposeBag)
        
        return output
    }
    
    private func convertPickerResultsToUIImages(_ pickerResults: [PHPickerResult]) -> Observable<[UIImage]> {
        return Observable.create { observer in
            var images: [UIImage] = []
            let dispatchGroup = DispatchGroup()
            
            for result in pickerResults {
                dispatchGroup.enter()
                
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let error = error {
                        print("Failed to load image: \(error)")
                        dispatchGroup.leave()
                        return
                    }
                    
                    if let image = object as? UIImage {
                        images.append(image.resize(width: 120))
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                observer.onNext(images)
                observer.onCompleted()
            }
            
            Logger.d("\(images)")
            
            return Disposables.create()
        }
    }
}
