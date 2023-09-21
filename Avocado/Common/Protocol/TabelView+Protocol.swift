//
//  TabelView+Protocol.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/21.
//

import Foundation
import UIKit
import RxSwift

protocol TableCellIdentifierable: UITableViewCell {
    // Cell 데이터타입을 정할 제네릭 타입
    associatedtype T
    
    // Cell identifier 변수 static으로 생성하여 메모리상으로 한번밖에 생성되지 않도록 함
    static var identifier:String {get}
    
    // Cell 데이터를 넘겨줄 Observer **실 사용 시 PublishSubject를 생성하여 해당 값을 구독하여 UI업데이트
//    var onData: AnyObserver<T> {get set}
    var disposeBag: DisposeBag {get}
}

protocol TabelViewLayoutable: AnyObject {
    // UICollectionView를 구성할 UICollectionViewCompositionalLayout 함수
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout
}
