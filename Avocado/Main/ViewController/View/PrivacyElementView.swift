//
//  PrivacyElementView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/06.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class PrivacyElementView : UIView {
    
    private var title : String
    
    private var discription: String
    
    lazy var titleLabel = UILabel().then {
        $0.text = self.title
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    lazy var discriptionLabel = UILabel().then {
        $0.text = self.discription
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .systemGray
    }
    
    override init(frame: CGRect) {
        self.title = ""
        self.discription = ""
        super.init(frame: .zero)
    }
    
    convenience init(type: PrivacyType,
                     require: Bool = false) {
        self.init(frame: .zero)
        
        self.title = type.title
        self.discription = type.discription
        
        //MARK: - UI 설정
        let stackView = buildStackView()
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        self.title = ""
        self.discription = ""
        super.init(coder: coder)
    }
    
    func buildStackView() -> UIStackView {
        
        let wapperView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(discriptionLabel)
        }
        
        wapperView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        return wapperView
    }
}

