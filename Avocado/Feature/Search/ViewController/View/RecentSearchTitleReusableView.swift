//
//  RecentSearchTitleReusableView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/14.
//

import UIKit
import RxSwift

final class RecentSearchTitleReusableView: UICollectionReusableView {
    static var identifier = "RecentSearchTitleReusableView"
    
    private lazy var titleLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.boldSystemFont(ofSize: 25)
        $0.textColor = .black
    }
    
    private lazy var deleteAllButton = UIButton().then {
        $0.setTitle("전체삭제", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    var deleteAllButtonTapObservable: Observable<Void> {
        return deleteAllButton.rx.tap.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, deleteAllButton].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(deleteAllButton.snp.left)
        }
        
        deleteAllButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(50)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, visible:Bool ) {
        titleLabel.text = title
        deleteAllButton.isHidden = visible
        // view를 다시 그릴때 DisposeBag 초기화
        disposeBag = DisposeBag()
    }
}
