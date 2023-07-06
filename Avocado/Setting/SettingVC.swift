//
//  SettingVC.swift
//  Avocado
//
//  Created by FOCUSONE Inc. on 2023/07/06.
//

import UIKit
import SafariServices

final class SettingVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "설정"
        $0.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    private lazy var googleSyncButton = SubButton(text: "구글 연동하기")
    private lazy var appleSyncButton = SubButton(text: "애플 연동하기")
    private let viewModel: SettingVM
    private let disposeBag = DisposeBag()
    
    init(vm: SettingVM) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setLayout() {
        [titleLabel, googleSyncButton, appleSyncButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setProperty() {
        view.backgroundColor = .white
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        googleSyncButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalTo(titleLabel)
        }
        
        appleSyncButton.snp.makeConstraints {
            $0.top.equalTo(googleSyncButton.snp.bottom).offset(20)
            $0.left.right.equalTo(titleLabel)
        }
    }
    
    override func bindUI() {
        googleSyncButton
            .rx
            .tap
            .asDriver()
            .do { _ in
                self.googleSyncButton.isEnabled = false
            }
            .drive(onNext: {
                [weak self]  in
                    self?.viewModel.googleSync()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .successEvent
            .asSignal()
            .emit(onNext: { [weak self] url in
                self?.googleSyncButton.isEnabled = true
                guard let url = URL(string: url) else { return }
                Logger.d(url)
                let safariViewController = SFSafariViewController(url: url)
                self?.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
            
    }

}
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SettingVCPreview: PreviewProvider {
    static var previews: some View {
        return UINavigationController(rootViewController: SettingVC(vm: SettingVM(service: SettingService()))).toPreview()
    }
}
#endif
