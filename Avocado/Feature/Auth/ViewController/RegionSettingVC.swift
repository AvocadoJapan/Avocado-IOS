//
//  RegionSettingVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then
import RxKeyboard
import CoreLocation

final class RegionSettingVC: BaseVC {

    private lazy var titleLabel = UILabel().then {
        $0.text = "직거래 지역 설정"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }

    private lazy var searchBar = SearchBarV(placeholder: "서울, 서초구, 강남 등")

    private lazy var confirmButton = BottomButton(text: "확인")
    
    private var locationManager = CLLocationManager().then {
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
        $0.startUpdatingLocation()
    }

    private let tableView = UITableView().then {
        $0.register(RegionTVCell.self, forCellReuseIdentifier: RegionTVCell.identifier)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.backgroundColor = .systemGray6
        $0.rowHeight = 40
        $0.showsVerticalScrollIndicator = false
        $0.isMultipleTouchEnabled = false
    }
    
    var viewModel: RegionSettingVM
    
    init(viewModel: RegionSettingVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 지역 정보 조회 API call
        viewModel.input.actionViewDidLoad.accept(())
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }

    override func setLayout() {
        [titleLabel, searchBar, tableView, confirmButton].forEach {
               view.addSubview($0)
       }
    }

    override func setConstraint() {
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(searchBar.snp.bottom).inset(-10)
            $0.bottom.equalTo(confirmButton.snp.top).inset(-10)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }

        searchBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
    }

    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        searchBar.searchBarTextFiled
            .rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.input.searchTextRelay)
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(Region.self)
            .subscribe(onNext: { [weak self] data in
                self?.viewModel.input.regionIdRelay.accept(data.id)
            })
            .disposed(by: disposeBag)
        
        confirmButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.viewModel.steps.accept(AuthStep.profileIsRequired)
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                self.confirmButton.keyboardMovement(from: self.view, height: height)
            })
            .disposed(by: disposeBag)
        
        //MARK: OUTPUT BINDING
        output.regionsRelay
            .bind(to: tableView.rx.items(cellIdentifier: RegionTVCell.identifier, cellType: RegionTVCell.self)) { _, region, cell in
                cell.configure(with: region)
            }
            .disposed(by: disposeBag)
        
        output.errorRelay
            .subscribe(onNext: { error in
                Logger.e(error.errorDescription)
            })
            .disposed(by: disposeBag)
    }

    // 커스텀 메소드
    @objc func didTapScrollView() {
        self.view.endEditing(true)
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct RegionSettingVCPreview: PreviewProvider {
    static var previews: some View {
        return RegionSettingVC(viewModel: RegionSettingVM(service: AuthService())).toPreview()
    }
}
#endif
