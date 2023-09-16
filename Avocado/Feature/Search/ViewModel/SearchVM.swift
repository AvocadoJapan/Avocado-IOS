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
        // 검색기록 삭제 버튼 클릭 시
        let actionRemoveButtonIndexPublish = PublishRelay<String>()
        // 검색기록 삭제 버튼 클릭 시
        let actionRemoveAllButtonIndexPublish = PublishRelay<Void>()
        // 유저가 텍스트를 입력했을때의 데이터
        let searchTextPublish = PublishRelay<String>()
    }
    
    struct Output {
        // 실제 collectionView에 보여질 데이터 리스트
        let recentSearchListPublish = PublishRelay<[RecentSearchSection]>()
        // 유저가 검색을 끝냈을 때 화면을 넘어가기 위한 데이터
        let successSearchEventPublish = PublishRelay<Void>()
        // 유저가 검색기록을 삭제했을때 데이터
        let successRemoveSearchEventPublish = PublishRelay<Void>()
        // 에러일 경우 데이터
        let errEventPublish = PublishRelay<AvocadoError>()
    }
    
    init(service: SearchService) {
        self.service = service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.actionRemoveAllButtonIndexPublish
            .flatMap { [weak self] in
                return self?.service.deleteAllRecentSearch() ?? .empty()
            }
            .bind(to: input.actionViewWillAppearPublish)
            .disposed(by: disposeBag)
        
        
        // 삭제 버튼 클릭 시
        input.actionRemoveButtonIndexPublish
            .flatMap { [weak self] content in
                return self?.service.deleteRecentSearch(content: content) ?? .empty()
            }
            .bind(to: input.actionViewWillAppearPublish)
            .disposed(by: disposeBag)
        
        // 사용자 검색 시
        input.searchTextPublish
            .flatMap { [weak self] keyword in
                return self?.service.addRecentSearch(content: keyword) ?? .empty()
            }
            .bind(to: output.successSearchEventPublish)
            .disposed(by: disposeBag)
        
        // 콜렉션 뷰 바인딩 및 검색기록 불러오기
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
