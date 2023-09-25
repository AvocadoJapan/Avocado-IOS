//
//  RxSearchBar.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/09.
//

import UIKit
import RxRelay
import RxSwift

/**
 * - description UISearchBar를 Rx로 래핑한 클래스
 */
final class RxSearchBar: UISearchBar {
    let disposeBag = DisposeBag()

    let searchButtonTappedPublish = PublishRelay<Void>() // 버튼 클릭
    var shouldLoadResultObservable = Observable<String>.of("") // 실제로 유저가 입력한 내용
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 기본 UI 설정
        setImage(UIImage(), for: .search, state: .normal)
        searchTextField.font = UIFont.boldSystemFont(ofSize: 14)
        searchTextField.backgroundColor = .systemGray6
        searchTextField.layer.cornerRadius = 20
        searchTextField.layer.masksToBounds = true
        searchTextField.borderStyle = .roundedRect
        
        // 유저가 검색버튼 클릭 시 실행
        self.rx.searchButtonClicked.asObservable()
            .bind(to: searchButtonTappedPublish)
            .disposed(by: disposeBag)
        
        // 유저가 키보드를 내렸을때 값으로 치환
        searchButtonTappedPublish
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
        
        // 실제로 키보드가 내려갔거나, 유저가 검색버튼을 클릭했을때
        shouldLoadResultObservable = searchButtonTappedPublish
            .withLatestFrom(self.rx.text) { $1 ?? "" } //유저가 마지막에 입력한 내용만 보냄
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/**
 * - description Rx에서는 의 EndEditing을 지원하지 않기 때문에 Rx에서 사용할 수 있도록 endEditing을 구현
 */
extension Reactive where Base: RxSearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
