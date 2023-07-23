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
import CoreLocation

final class RegionSettingVM {
    
    let authService: AuthService
    let disposeBag = DisposeBag()
    var searchTextRelay = BehaviorRelay<String>(value: "")
    let regionIdRelay = BehaviorRelay<String>(value: "")
    let regionsRelay = BehaviorRelay<[Region]>(value: [])
    let locationRelay = BehaviorRelay<CLLocation?>(value: nil)
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
    
    private var locationManager = CLLocationManager().then {
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
        $0.startUpdatingLocation()
    }
    
    init(service: AuthService) {
        self.authService = service
        
        searchTextRelay
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.fetchRegion()
            })
            .disposed(by: disposeBag)
    }
    
    func fetchRegion() {
        authService.getRegions(keyword: searchTextRelay.value, depth: 3)
            .subscribe { regions in
                self.regionsRelay.accept(regions)
            } onError: { err in
                // 여기에 에러 구현
            }
            .disposed(by: disposeBag)
    }
    
    /**
     * - Description 현재 위치 주소를 가져오는 Observable
     * - Returns 현재 주소
     */
    func getCurrentAddress() -> Observable<String> {
        return Observable.create { [weak self] observer in
            let geocoder = CLGeocoder()
            
            guard let location = self?.locationManager.location else {
                return Disposables.create()
            }
            
            geocoder.reverseGeocodeLocation(location) { placeMarks, err in
                if let err = err {
                    Logger.e(err)
                    return
                }
                
                guard let placemark = placeMarks?.first else {
                    return
                }
                
                var address = ""
                
                if let administrativeArea = placemark.administrativeArea {
                    address = "\(administrativeArea)"
                }
                
                if let locality = placemark.locality {
                    address.append(locality)
                }
                
                if let thoroughfare = placemark.thoroughfare {
                    address.append(thoroughfare)
                }
                
                Logger.d(address)
                observer.onNext(address)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
