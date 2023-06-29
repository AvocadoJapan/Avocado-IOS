//
//  BaseModal.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/28.
//

import Foundation
import UIKit

final class ModalVC: UIViewController {
    
    private var dimView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        $0.backgroundColor = .systemPink
      }
    
    private var popUpView = UIView().then {
        $0.backgroundColor = .systemPink
    }
    
    fileprivate lazy var titleLabel = UILabel().then {
        $0.text = "Set Filters"
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
    }
    
    fileprivate lazy var descriptionLabel = UILabel().then {
        $0.text = "Order By"
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    
    private var okButtonConfig = UIButton.Configuration.filled()
    
//    fileprivate lazy var okButton = UIButton().then {
//        $0.configuration = .filled()
//        okButtonConfig.title = "OK"
//        okButtonConfig.baseBackgroundColor = .black
//        okButtonConfig.cornerStyle = .capsule
//        okButtonConfig.titlePadding = 10
//        $0.configuration = self.okButtonConfig
//    }
    
    private lazy var confirmButton : BottomButton = BottomButton(text: "OK")
    
    
    // lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configProperty()
        configLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let presentingView = self.presentingViewController?.view else {
            return
        }
        
        presentingView.addSubview(dimView)
        
        dimView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 1
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0
        } completion: { _ in
            self.dimView.removeFromSuperview()
        }
    }
}

// MARK: - Setting Self
extension ModalVC {
    // self stored property
    fileprivate func configProperty() {
//        self.view.backgroundColor = .white
    }
}

// MARK: - addSubview / autolayout
extension ModalVC {
    fileprivate func configLayout() {
        
        view.addSubview(popUpView)
        
        popUpView.addSubview(titleLabel)
        popUpView.addSubview(descriptionLabel)

        popUpView.addSubview(confirmButton)
        
        popUpView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(300)
            $0.horizontalEdges.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(13)
        }
        
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(50)
        }
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ModalVCPreview: PreviewProvider {
    static var previews: some View {
        return ModalVC().toPreview()
    }
}
#endif
