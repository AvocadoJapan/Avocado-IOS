//
//  SearchVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/03.
//

import Foundation
import RxRelay
import RxSwift
import RxFlow

final class SearchVM: ViewModelType {
    var steps = PublishRelay<Step>()
    let service: SearchService
    var disposeBag = DisposeBag()
    private (set) var input: Input
    
    struct Input {
        // 화면이 보여질 경우의 데이터
        let actionViewWillAppearPublish = PublishRelay<Void>()
        // 유저가 텍스트를 입력했을때의 데이터
        let searchTextPublish = PublishRelay<String>()
    }
    
    struct Output {
        // 실제 collectionView에 보여질 데이터 리스트
        let recentSearchListPublish = PublishRelay<[RecentSearchSection]>()
        // 유저가 검색을 끝냈을 때 화면을 넘어가기 위한 데이터
        let successSearchEventPublish = PublishRelay<Void>()
        
        // 에러일 경우 데이터
        let errEventPublish = PublishRelay<AvocadoError>()
    }
    
    init(service: SearchService) {
        self.service = service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.searchTextPublish
            .flatMap { [weak self] keyword in
                return self?.service.addRecentSearch(content: keyword) ?? .empty()
            }
            .bind(to: output.successSearchEventPublish)
            .disposed(by: disposeBag)
        
        input.actionViewWillAppearPublish
            .flatMap { [weak self] in
                return self?.service.loadRecentSearchList() ?? .empty()
            }
            .map { recentSearchList -> [RecentSearchSection] in
                return [RecentSearchSection(header: "최근 검색어", items: recentSearchList)]
            }
            .bind(to: output.recentSearchListPublish)
            .disposed(by: disposeBag)
        
        return output
    }
}
