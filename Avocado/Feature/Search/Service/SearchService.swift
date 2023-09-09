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
    
    func addRecentSearch(content: String) -> Observable<Void> {
        return Observable.create { observer in
            
            let task = Task {
                let instance = try! Realm()
                
                var index = 0
                if let lastData = instance
                    .objects(RecentSearchEntity.self)
                    .last { index = lastData.id + 1 }
                
                let searchData = RecentSearchEntity()
                searchData.content = content
                searchData.createdAt = Int64(Date().timeIntervalSince1970)
                searchData.id = index
//                Logger.d("SearchData = \(searchData)")
//                Logger.d("file Path = \(Realm.Configuration.defaultConfiguration.fileURL)")
                
                try? instance.write { instance.add(searchData) }
                
                observer.onNext(())
                observer.onCompleted()
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
    func deleteRecentSearch(index: Int) {
        let instance = try! Realm()
        if let recentSearchData = instance
            .objects(RecentSearchEntity.self)
            .filter(NSPredicate(format: "id = %d", index))
            .first {
            
            try? instance.write {
                instance.delete(recentSearchData)
            }
            
        }
        else {
            Logger.e("삭제 오류 발생")
        }
    }
    
    func loadRecentSearchList() -> Observable<[RecentSearchEntity]> {
        return Observable.create { observer in
            
            let instance = try! Realm()
            let recentSearchList = Array(instance.objects(RecentSearchEntity.self))
            Logger.d("recent = \(recentSearchList)")
            observer.onNext(recentSearchList)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
