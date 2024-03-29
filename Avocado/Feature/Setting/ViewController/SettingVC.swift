//
//  SettingVC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/06.
//

import UIKit
import SafariServices
import RxDataSources
import RxSwift

final class SettingVC: BaseVC {
    
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.register(SettingTVCell.self, forCellReuseIdentifier: SettingTVCell.identifier)
        $0.rowHeight = 60
    }
    
    private let viewModel: SettingVM
    
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
        view.addSubview(tableView)
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        
        //navigationContorller set
        title = "설정"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // searchController set
        setSearchController()
    }
    
    override func setConstraint() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        //tableview bind
        let dataSource = RxTableViewSectionedReloadDataSource<SettingDataSection> { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTVCell.identifier, for: indexPath) as? SettingTVCell else {
                return UITableViewCell()
            }
            
            // cell configure
            cell.configureCell(data: item)
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].title
        }
            
        tableView
            .rx
            .modelSelected(SettingData.self)
            .subscribe(onNext: { [weak self] data in
                switch data.type {
                case .syncSocial(type: let type): // 소셜 연동하기
                    self?.viewModel.input.actionSocialSync.accept(type)

                case .userLogOut: // 유저 로그아웃
                    self?.viewModel.input.actionUserLogout.accept(())

                case .deleteAccount: // 유저 계정 탈퇴
                    let alertController = UIAlertController(title: "", message: "'Avocado'를 탈퇴하시겠습니까?", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self?.viewModel.input.actionUserDeleteAccount.accept(())
                    }))
                    
                    alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
                    
                    self?.present(alertController, animated: true)
                    
                }
            })
            .disposed(by: disposeBag)
        
        // Output
        output.staticSettingData
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 소셜 연동
        output.successSocialSyncEvent
            .asSignal()
            .emit(onNext: { [weak self] url in
                guard let url = URL(string: url) else { return }
                Logger.d(url)
                let safariViewController = SFSafariViewController(url: url)
                self?.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 로그아웃
        output.successLogOutEvent
            .asSignal()
            .emit(onNext: { [weak self] _ in
                let service = AuthService()
                let welcomeVM = WelcomeVM(service: service)
                let welcomeVC = WelcomeVC(viewModel: welcomeVM)
                let baseNavigationController = welcomeVC.makeBaseNavigationController()
                baseNavigationController.modalPresentationStyle = .fullScreen
                self?.present(baseNavigationController, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 계정 삭제
        output.successDeleteAccountEvent
            .asSignal()
            .emit(onNext: { [weak self] _ in
                let service = AuthService()
                let welcomeVM = WelcomeVM(service: service)
                let welcomeVC = WelcomeVC(viewModel: welcomeVM)
                let baseNavigationController = welcomeVC.makeBaseNavigationController()
                baseNavigationController.modalPresentationStyle = .fullScreen
                self?.present(baseNavigationController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색할 내용을 입력하세요"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
