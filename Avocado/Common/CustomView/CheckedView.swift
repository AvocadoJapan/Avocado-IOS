//
//  CheckedView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/03.
//

import UIKit
/**
 * - description 체크표시가 되어있는 화면 { 본인인증 확인과 같은 화면에 사용 }
 */
final class CheckedView: UIView {
    
    lazy var checkImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark")
        $0.tintColor = .black
    }
    lazy var verifiedTitleLabel = UILabel().then {
        $0.text = "이메일 주소"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [checkImageView, verifiedTitleLabel].forEach {
            addSubview($0)
        }
        
        checkImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(0)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(30)
        }
        
        verifiedTitleLabel.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.left.equalTo(checkImageView.snp.right).offset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String) {
        super.init(frame: .zero)
        verifiedTitleLabel.text = title
    }
    
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct CheckedViewPreview: PreviewProvider {
    static var previews: some View {
        return CheckedView().toPreview().previewLayout(.fixed(width: 414, height: 100))
    }
}
#endif
