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
                return [
                    SearchResultSection(
                        header: input.userSearchKewordPublish.value,
                        categorys: result.category,
                        items: result.products
                    )
                ]
            }
            .bind(to: output.successSearchResultListPublish)
            .disposed(by: disposeBag)
        
        input.userSearchKewordPublish
            .flatMap { [weak self] keyword in
                // 키워드 Realm에 저장
                return self?.service.addRecentSearch(content: keyword)
                    .flatMap {
                        return self?.service.searchResultList(keyword: keyword)
                            .catch { _ in
                                return .empty()
                            } ?? .empty()
                    } ?? .empty()
            }
            .map { result -> [SearchResultSection] in
                return [
                    SearchResultSection(
                        header: input.userSearchKewordPublish.value,
                        categorys: result.category,
                        items: result.products
                    )
                ]
            }
            .bind(to: output.successSearchResultListPublish)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
