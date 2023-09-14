//
//  SearchResultVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/14.
//

import Foundation
import RxSwift
import RxRelay
import RxFlow

final class SearchResultVM: ViewModelType {

    var service: SearchService
    var disposeBag = DisposeBag()
    let steps: PublishRelay<Step> = PublishRelay()
    var input: Input
    
    struct Input {
        let userSearchKewordPublish: BehaviorRelay<String>
    }
    
    struct Output {
        let successSearchResultListPublish = PublishRelay<[SearchResultSection]>()
    }
    
    init(service: SearchService, keyword: String) {
        self.service = service
        input = Input(userSearchKewordPublish: BehaviorRelay<String>(value: keyword))
    }
                  
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.userSearchKewordPublish.flatMap { [weak self] keyword in
            return self?.service.searchResultList(keyword: keyword) ?? .empty()
        }
        .map { result -> [SearchResultSection] in
            let categoryList = result.category.map { SearchResultSection.SearchResultSectionItem.category(data: $0) }
            let productList = result.products.map { SearchResultSection.SearchResultSectionItem.product(data: $0) }
            
            return [
                SearchResultSection(items: categoryList),
                SearchResultSection(header: "\(input.userSearchKewordPublish.value) 검색결과", items: productList)
            ]
        }
        .bind(to: output.successSearchResultListPublish)
        .disposed(by: disposeBag)
        
        return output
    }
    
}
