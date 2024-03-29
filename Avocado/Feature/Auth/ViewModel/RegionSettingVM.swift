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
import RxFlow

final class RegionSettingVM: ViewModelType, Stepper {
    
    let service: AuthService
    var disposeBag = DisposeBag()
    var steps: PublishRelay<Step> = PublishRelay() // RxFlow 처리 Step
    private (set) var input: Input
    
    private var locationManager = CLLocationManager().then {
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
        $0.startUpdatingLocation()
    }
    
    struct Input {
        var searchTextPublish = PublishRelay<String>()
        let regionIdBehavior = BehaviorRelay<String>(value: "")
        let actionViewDidLoadPublish = PublishRelay<Void>()
    }
    
    struct Output {
        let regionsBehavior = BehaviorRelay<[Region]>(value: [])
        let locationBehavior = BehaviorRelay<CLLocation?>(value: nil)
        let errorEventPublish = PublishRelay<AvocadoError>()
    }
    
    init(service: AuthService) {
        self.service = service
        self.input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.actionViewDidLoadPublish
            .flatMap { [weak self] _ -> Observable<Regions> in
                return self?.service.getRegions(
                    keyword: "",
                    depth: 3
                )
                .catch { error in
                    Logger.e("::: viewDidLoad asdasdasdasd")
                    if let error = error as? AvocadoError { output.errorEventPublish.accept(error) }
                    return .empty()
                } ?? .empty()
        }
        .subscribe { output.regionsBehavior.accept($0) }
        .disposed(by: disposeBag)
        
        input.searchTextPublish
            .debounce(RxTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap { [weak self] keyword -> Observable<Regions> in
                return self?.service.getRegions(
                    keyword: keyword,
                    depth: 3
                )
                .catch { error in
                    if let error = error as? AvocadoError { output.errorEventPublish.accept(error) }
                    return .empty()
                } ?? .empty()
            }
            .subscribe { output.regionsBehavior.accept($0) }
            .disposed(by: disposeBag)
        
        return output
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
