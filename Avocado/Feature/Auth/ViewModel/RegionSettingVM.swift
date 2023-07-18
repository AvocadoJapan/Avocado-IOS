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
    
    let authService: AuthService
    let disposeBag = DisposeBag()
    var searchTextRelay = BehaviorRelay<String>(value: "")
    let regionIdRelay = BehaviorRelay<String>(value: "")
    let regionsRelay = BehaviorRelay<[Region]>(value: [])
    var isValid: Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            
            observer.onNext(self.regionIdRelay.value.isEmpty)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    init(service: AuthService) {
        self.authService = service
    }
    
    func fetchRegion() {
        authService.getRegions(keyword: searchTextRelay.value, depth: 3)
            .subscribe { regions in
                self.regionsRelay.accept(regions)
            } onError: { err in
                
            }
            .disposed(by: disposeBag)
    }
}
