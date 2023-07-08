//
//  SettingVC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/06.
//

import UIKit
import SafariServices
import RxDataSources

final class SettingVC: BaseVC {
    
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.register(SettingTC.self, forCellReuseIdentifier: SettingTC.identifier)
        $0.rowHeight = 60
    }
    
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
        viewModel
            .successEvent
            .asSignal()
            .emit(onNext: { [weak self] url in
                guard let url = URL(string: url) else { return }
                Logger.d(url)
                let safariViewController = SFSafariViewController(url: url)
                self?.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        //tableview bind
        let dataSource = RxTableViewSectionedReloadDataSource<SettingDataSection> { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTC.identifier, for: indexPath) as? SettingTC else {
                return UITableViewCell()
            }
            
            // cell configure
            cell.configureCell(data: item)
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].title
        }
            
        
        viewModel
            .staticSettingData
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setSearchController() {
        let searchController = UISearchController(searchResultsController: self)
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
