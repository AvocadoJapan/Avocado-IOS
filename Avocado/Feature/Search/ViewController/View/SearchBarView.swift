//
//  SearchBarV.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/04.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxRelay

final class SearchBarV: UIView {
    
    private lazy var searchView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 10
    }
    
    private lazy var searchImageView = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.contentMode = .scaleAspectFit
        UIImageView.appearance().tintColor = .darkGray
    }
    
    var searchBarTextFiled = UITextField().then {
        $0.font = .systemFont(ofSize: 13)
        UITextField.appearance().tintColor = .black
    }
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        [searchImageView, searchBarTextFiled].forEach {
            searchView.addSubview($0)
        }
        addSubview(searchView)
        
        searchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        searchImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.left.equalTo(searchView.snp.left).offset(15)
            $0.centerY.equalToSuperview()
        }
        
        searchBarTextFiled.snp.makeConstraints {
            $0.left.equalTo(searchImageView.snp.right).offset(10)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(placeholder : String) {
        self.init(frame: .zero)
        
        self.searchBarTextFiled.placeholder = placeholder
        
        searchBarTextFiled.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                self?.searchBarTextFiled.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
    }
    
    // override touchesBegan (키보드 내리기)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBarTextFiled.resignFirstResponder()
    }
}


#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct SearchBarVPreview:PreviewProvider {
    static var previews: some View {
        return SearchBarV().toPreview().previewLayout(.fixed(width: 400, height: 50))
    }
}
#endif
