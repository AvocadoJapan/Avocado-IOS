//
//  MainService.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/12.
//

import Foundation
import RxSwift

final class MainService: BaseAPIService<MainAPI> {
    
    // Observable처리 disposeBag
    private let disposeBag = DisposeBag()
    
    func getMain() -> Observable<MainDataModel> {
        return singleRequest(.main)
                .asObservable()
    }
    
    // ProductSection
    func getSingleCategoryProductList(id: String) -> Observable<ProductSection> {
        return singleRequest(.singleCategory(id: id))
            .asObservable()
    }
}
