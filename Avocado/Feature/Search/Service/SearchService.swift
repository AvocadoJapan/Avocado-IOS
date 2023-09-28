//
//  SearchService.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/09.
//

import Foundation
import RxSwift
import RealmSwift

final class SearchService:BaseAPIService<SearchAPI> {
    /**
     * - description Realm에 데이터 추가 메서드, 중복된 값이 있을 경우 업데이트
     * - parameter content 추가 할 값
     */
    func addRecentSearch(content: String) -> Observable<Void> {
        return Observable.create { observer in
            
            let instance = try! Realm()
            // 검색 리스트
            let recentSearchList = Array(instance.objects(RecentSearchEntity.self))
            
            // 중복된 값이 있을 경우 값을 업데이트
            let searchData = RecentSearchEntity()
            searchData.content = content
            searchData.createdAt = Int64(Date().timeIntervalSince1970)
            
            // 데이터 삽입
            try? instance.write { instance.add(searchData, update: .modified) }
            
            // 검색 리스트의 개수가 6개 초과할 경우 가장 오래된 데이터를 삭제
            if recentSearchList.count > 6 {
                if let lastData = instance
                        .objects(RecentSearchEntity.self)
                        .sorted(byKeyPath: "createdAt", ascending: false)
                        .last {
                    
                    try? instance.write { instance.delete(lastData) }
                }
            }
            
            observer.onNext(())
            observer.onCompleted()
            
            return Disposables.create()
            
        }
    }
    /**
     * - description Realm에 데이터 삭제 메서드
     * - parameter content 삭제 할 값
     */
    func deleteRecentSearch(content: String) -> Observable<Void> {
        return Observable.create { observer in
            
            let instance = try! Realm()
            if let recentSearchData = instance
                .objects(RecentSearchEntity.self)
                .filter(NSPredicate(format: "content = %@", content))
                .first {
                
                try? instance.write { instance.delete(recentSearchData) }
                observer.onNext(())
                observer.onCompleted()
            }
            else {
                Logger.e("삭제 오류 발생")
            }
            
            return Disposables.create()
        }
    }
    /**
     * - description Realm에 테이블 전체 삭제 메서드
     */
    func deleteAllRecentSearch() -> Observable<Void> {
        return Observable.create { observer in
            
            let instance = try! Realm()
            
            try? instance.write { instance.deleteAll() }
            observer.onNext(())
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    /**
     * - description Realm 테이블에 저장되어있는 정보 로드 함수
     */
    func loadRecentSearchList() -> Observable<[RecentSearchEntity]> {
        return Observable.create { observer in
            
            let instance = try! Realm()
            
            let searchResult = instance
                .objects(RecentSearchEntity.self)
                .sorted(byKeyPath: "createdAt", ascending: false)
            
            let recentSearchList = Array(searchResult)
//            Logger.d("recent = \(recentSearchList)")
            observer.onNext(recentSearchList)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    /**
     * - description 검색결과를 가져오는 API 함수
     */
    func searchResultList(keyword: String) -> Observable<SearchResult> {
        return singleRequest(.searchResult(keyword: keyword)).asObservable()
    }
}
