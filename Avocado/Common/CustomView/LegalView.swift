//
//  LegalView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/16.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class LegalView: UIView {
    
    private let title : String
    
    private let discription: String
    
    private let copyright: String
    
    lazy var titleLabel = UILabel().then {
        $0.text = self.title
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        $0.textColor = .darkGray
    }
    
    lazy var discriptionLabel = UILabel().then {
        $0.text = self.discription
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .systemGray
    }
    
    lazy var copyrightLabel = UILabel().then {
        $0.text = self.copyright
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .systemGray
    }
    
    override init(frame: CGRect) {
        self.title = "株式会社アボカド事業者情報、利用規約およびその他の法的通知"
        self.discription = "株式会社アボカド（以下、アボカド）は、通信販売の仲介者であり、通信販売の当事者ではありません。電子商取引などの消費者保護に関する法律などの関連法規及びアボカドの規約に従い、商品、商品情報、取引に関する責任は個々の販売者に帰属し、アボカドは原則として会員間の取引に対して責任を負いません。また、プライバシーポリシーに関しましては、弊社グループで取得情報を管理・利用する業務に従事する者は、お客様の取得情報について厳重に管理を行い、個人情報への不当なアクセス、紛失、漏洩、改ざん等が起きないよう、取得情報の取り扱いに十分な注意を払い、その業務に努めます。"
        
        self.copyright = "Copyright 2023 AvocadoLabs All RIGHTS RESERVED"
        
        
        super.init(frame: .zero)
        
        self.backgroundColor = .systemGray6
        
        //MARK: - UI 설정
        let stackView = buildStackView()
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(250)
        }
    }
    required init?(coder: NSCoder) {
        self.title = "株式会社アボカド事業者情報、利用規約およびその他の法的通知"
        self.discription =
                    """
                    株式会社アボカド（以下、アボカド）は、通信販売の仲介者であり、通信販売の当事者ではありません。電子商取引などの消費者保護に関する法律などの関連法規及びアボカドの規約に従い、商品、商品情報、取引に関する責任は個々の販売者に帰属し、アボカドは原則として会員間の取引に対して責任を負いません。また、プライバシーポリシーに関しましては、弊社グループで取得情報を管理・利用する業務に従事する者は、お客様の取得情報について厳重に管理を行い、個人情報への不当なアクセス、紛失、漏洩、改ざん等が起きないよう、取得情報の取り扱いに十分な注意を払い、その業務に努めます。
                    """
        self.copyright = "Copyright 2023 AvocadoLabs All RIGHTS RESERVED"
        
        super.init(coder: coder)
    }
    
    func buildStackView() -> UIStackView {
        
        let wapperView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .fill
            $0.spacing = 10
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(discriptionLabel)
            $0.addArrangedSubview(copyrightLabel)
        }
        
        return wapperView
    }
}


