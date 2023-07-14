//
//  FailVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/14.
//

import Foundation
import UIKit
import Then
import RxSwift
import RxFlow
import RxCocoa
import RxRelay

final class FailVC : BaseVC {
    
    var errorText: String = "알수없는 오류 발생"
    
    lazy var errorLabel = UILabel().then {
        $0.text = errorText
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    override func setProperty() {
        view.backgroundColor = UIColor(hexCode: "085E05")
    }
    
    override func setLayout() {
        view.addSubview(errorLabel)
    }
    
    override func setConstraint() {
        errorLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}


#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct FailVCPreview: PreviewProvider {
    static var previews: some View {
        return FailVC().toPreview().ignoresSafeArea()
    }
}
#endif
