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
        let actionViewDidLoad  = PublishRelay<Void>()
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
        
        //FIXME: userSearchKewordPublish 하나로만 가능하도록 고도화 필요
        input.actionViewDidLoad
            .flatMap { [weak self] in
                return self?.service.searchResultList(keyword: input.userSearchKewordPublish.value) ?? .empty()
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
        
        input.userSearchKewordPublish
            .flatMap { [weak self] keyword in
                // 키워드 Realm에 저장
                return self?.service.addRecentSearch(content: keyword)
                    .flatMap {
                        return self?.service.searchResultList(keyword: keyword) ?? .empty()
                    } ?? .empty()
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
