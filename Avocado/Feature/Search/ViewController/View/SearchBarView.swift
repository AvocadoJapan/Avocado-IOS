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

final class SearchBarView: UIView {
    
    private lazy var searchView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 10
    }
    
    private lazy var searchImageView = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.contentMode = .scaleAspectFit
        UIImageView.appearance().tintColor = .darkGray
    }
    
    private var searchBarTextField = UITextField().then {
        $0.font = .systemFont(ofSize: 13)
        UITextField.appearance().tintColor = .black
    }
    
    public var userInput = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        [searchImageView, searchBarTextField].forEach {
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
        
        searchBarTextField.snp.makeConstraints {
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
        
        self.searchBarTextField.placeholder = placeholder
        
        // userInputBinding
        searchBarTextField
            .rx
            .text
            .orEmpty
            .filter { !$0.isEmpty }
            .bind(to: userInput)
            .disposed(by: disposeBag)
        
        searchBarTextField
            .rx
            .controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                self?.searchBarTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
    }
    
    /**
     * - Description 키보드 hidden 메서드
     */
    public func keyboardHidden() {
        searchBarTextField.resignFirstResponder()
    }
    
    // override touchesBegan (키보드 내리기)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBarTextField.resignFirstResponder()
    }
}


#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct SearchBarVPreview:PreviewProvider {
    static var previews: some View {
        return SearchBarView().toPreview().previewLayout(.fixed(width: 400, height: 50))
    }
}
#endif
