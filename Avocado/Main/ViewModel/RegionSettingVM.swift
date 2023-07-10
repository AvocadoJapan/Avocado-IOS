//
//  RegionSettingVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class RegionSettingVM {
    
    let service: AuthService
    let disposeBag = DisposeBag()
    var textOb = BehaviorRelay<String>(value: "")
    let regionIdOb = BehaviorRelay<String>(value: "")
    let regions = BehaviorRelay<[Region]>(value: [])
    var isVaild: Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            
            observer.onNext(self.regionIdOb.value.isEmpty)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    init(service: AuthService) {
        self.service = service
    }
    
    func fetchRegion() {
        service.getRegions(keyword: textOb.value, depth: 3)
            .subscribe { regions in
                self.regions.accept(regions)
            } onError: { err in
                
            }
            .disposed(by: disposeBag)
    }
}
