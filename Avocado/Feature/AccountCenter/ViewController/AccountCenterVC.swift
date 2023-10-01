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
import RxDataSources

final class AccountCenterVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "계정 센터"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 25,
                                    weight: .heavy)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "계정관련 도움이 필요하신가요?"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14,
                                    weight: .semibold)
    }
    
    private lazy var accountMenuTV = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        
        $0.backgroundColor = .white
        $0.separatorStyle = .none
    }
    
    private let viewModel: AccountCenterVM
    
    init(viewModel: AccountCenterVM) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setViewDidLoad() {
        // 초기 메인데이터 API call]
        viewModel.input.actionViewDidLoadPublish.accept(())
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 선택된 셀 해제
        if let selectedIndexPath = accountMenuTV.indexPathForSelectedRow {
            accountMenuTV.deselectRow(at: selectedIndexPath, animated: false)
        }
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        // accountTV 셀등록
        accountMenuTV.register(AccountMenuTVCell.self,
                               forCellReuseIdentifier: AccountMenuTVCell.identifier)
    }
    
    override func setLayout() {
        [titleLabel, descriptionLabel, accountMenuTV].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
//            $0.left.equalToSuperview().offset(30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
//            $0.left.equalToSuperview().offset(30)
        }
        
        accountMenuTV.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        accountMenuTV.rx.setDelegate(self).disposed(by: disposeBag)
        
        // 셀을 누를 경우 actionTVCellRelay에 타입전달
        accountMenuTV
            .rx
            .modelSelected(AccountCenterDataSection.Item.self)
            .subscribe { [weak self] item in
                self?.viewModel.input.actionTVCellRelay.accept(item.element!.type)
            }
            .disposed(by: disposeBag)
        
        
        // 아직 지원하지 않는 셀을 누를경우 SPIndicator 표시 후 셀 선택 해제
        accountMenuTV.rx.modelSelected(AccountCenterDataSection.Item.self)
            .filter { $0.type == .findEmail ||
                $0.type == .code2FAUnvalid ||
                $0.type == .signInError ||
                $0.type == .signUpError }
            .do(onNext: { [weak self] _ in
                if let selectedIndexPath = self?.accountMenuTV.indexPathForSelectedRow {
                    self?.accountMenuTV.deselectRow(at: selectedIndexPath, animated: false)
                }
            })
            .subscribe(onNext: { _ in
                SPIndicator.present(title: "앗, 잠시만요", message: "지원하지 않는 기능이에요", preset: .error, haptic: .error)
            })
            .disposed(by: disposeBag)
        
        // 바인딩을 위한 데이터소스 정의
        let dataSource = RxTableViewSectionedReloadDataSource<AccountCenterDataSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: AccountMenuTVCell.identifier, for: indexPath) as! AccountMenuTVCell
                
                cell.configCell(data: item)
                
                return cell
            }, // configureCell
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].title
            }
        )
        
        // dataSectionPublish를 테이블뷰에 바인딩
        output.dataSectionPublish
            .bind(to: accountMenuTV.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension AccountCenterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
import SPIndicator
struct AccountCenterVCPreview: PreviewProvider {
    static var previews: some View {
        return AccountCenterVC(viewModel: AccountCenterVM(service: AccountCenterService())).toPreview()
    }
}
#endif
