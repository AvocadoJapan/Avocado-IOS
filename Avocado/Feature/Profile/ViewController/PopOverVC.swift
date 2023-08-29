//
//  PopOverViewController.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import UIKit

final class PopOverVC: BaseVC {
    
    lazy var titleLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    init(title: String, description: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setLayout() {
        [titleLabel, descriptionLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.left.right.top.equalToSuperview().inset(8)
            $0.height.equalTo(descriptionLabel.snp.height).multipliedBy(0.5)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalTo(titleLabel)
            $0.bottom.equalToSuperview()
        }
    }

}
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct PopOverVCPreview: PreviewProvider {
    static var previews: some View {
        return PopOverVC(title: "프리미엄 판매자와 본인 인증이 무엇인가요 ?", description: "프리미엄 판매자란, 구매자와 좋은 거래를 맞춰 인증된 사용자를 말합니다.프리미엄 판매자란, 구매자와 좋은 거래를 맞춰 인증된 사용자를 말합니다.프리미엄 판매자란, 구매자와 좋은 거래를 맞춰 인증된 사용자를 말합니다.").toPreview().previewLayout(.fixed(width: 200, height: 120))
    }
}
#endif
