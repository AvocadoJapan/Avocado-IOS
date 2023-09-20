//
//  AccountCenterVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/20.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then
import Localize_Swift

final class AccountCenterVC: BaseVC {
    
    private lazy var logo = UIImageView().then {
        $0.image = UIImage(named: "logo_avocado")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "계정 센터"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
//    private lazy var tableView = UITableView().then {
//        $0.
//    }
    
//    private let viewModel: WelcomeVM
    
    init(viewModel: WelcomeVM? = nil) {
//        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setLayout() {
        [logo, titleLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        logo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalToSuperview().offset(30)
            $0.size.equalTo(55)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(30)
        }
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
import SPIndicator
struct AccountCenterVCPreview: PreviewProvider {
    static var previews: some View {
        return AccountCenterVC().toPreview()
    }
}
#endif
