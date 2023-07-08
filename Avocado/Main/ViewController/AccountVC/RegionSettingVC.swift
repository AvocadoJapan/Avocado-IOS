import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then
import RxKeyboard

final class RegionSettingVC: BaseVC {

    private lazy var titleLabel = UILabel().then {
        $0.text = "직거래 지역 설정"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }

    private lazy var searchBar = SearchBarV(placeholder: "서울, 서초구, 강남 등")

    private lazy var confirmButton = BottomButton(text: "확인")

    private let tableView = UITableView().then {
        $0.register(RegionTVCell.self, forCellReuseIdentifier: RegionTVCell.identifier)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.backgroundColor = .systemGray6
        $0.rowHeight = 40
        $0.showsVerticalScrollIndicator = false
        $0.isMultipleTouchEnabled = false
    }

    var disposeBag = DisposeBag()
    var viewModel: RegionSettingVM
    
    init(vm viewModel: RegionSettingVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Dummy data for table view
    private let regions: [Region] = [
        Region(regionId: 1, name: "서울특별시 종로구 청운동"),
        Region(regionId: 2, name: "서울특별시 종로구 신교동"),
        Region(regionId: 3, name: "서울특별시 종로구 궁정동"),
        Region(regionId: 4, name: "서울특별시 종로구 효자동"),
        Region(regionId: 5, name: "서울특별시 용산구 이촌동"),
        Region(regionId: 6, name: "서울특별시 종로구 청운동"),
        Region(regionId: 7, name: "서울특별시 종로구 신교동"),
        Region(regionId: 8, name: "서울특별시 종로구 궁정동"),
        Region(regionId: 9, name: "서울특별시 종로구 효자동"),
        Region(regionId: 10, name: "서울특별시 용산구 이촌동"),
        Region(regionId: 11, name: "서울특별시 종로구 청운동"),
        Region(regionId: 12, name: "서울특별시 종로구 신교동"),
        Region(regionId: 13, name: "서울특별시 종로구 궁정동"),
        Region(regionId: 14, name: "서울특별시 종로구 효자동"),
        Region(regionId: 15, name: "서울특별시 용산구 이촌동"),
        Region(regionId: 16, name: "서울특별시 종로구 청운동"),
        Region(regionId: 17, name: "서울특별시 종로구 신교동"),
        Region(regionId: 18, name: "서울특별시 종로구 궁정동"),
        Region(regionId: 19, name: "서울특별시 종로구 효자동"),
        Region(regionId: 20, name: "서울특별시 용산구 이촌동"),
        Region(regionId: 21, name: "서울특별시 종로구 청운동"),
        Region(regionId: 22, name: "서울특별시 종로구 신교동"),
        Region(regionId: 23, name: "서울특별시 종로구 궁정동"),
        Region(regionId: 24, name: "서울특별시 종로구 효자동"),
        Region(regionId: 25, name: "서울특별시 용산구 이촌동"),
    ]

    override func setProperty() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.tableView.isMultipleTouchEnabled = false
    }

    override func setLayout() {
        [tableView, titleLabel, searchBar, tableView, confirmButton].forEach {
            view.addSubview($0)
        }

//        scrollView.addSubview(containerView)
    }

    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }

        searchBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.left.equalToSuperview().offset(20)
        }
    }

    override func bindUI() {
        
        searchBar.searchBarTextFiled
            .rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .do(onNext: { text in
                    print("Text changed to: \(text)")
                })
            .bind(to: viewModel.textOb)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: {
                self.confirmButton.keyboardMovement(from: self.view, height: $0)
            })
            .disposed(by: disposeBag)

        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                if height > 0 {
                    self?.navigationController?.setNavigationBarHidden(true, animated: true)
                } else {
                    self?.navigationController?.setNavigationBarHidden(false, animated: true)
                }
            })
            .disposed(by: disposeBag)

        // Table view data source binding
        Observable.just(regions)
            .bind(to: tableView.rx.items(cellIdentifier: RegionTVCell.identifier, cellType: RegionTVCell.self)) { _, region, cell in
                cell.configure(with: region)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .checkmark
                }
            })
            .disposed(by: disposeBag)
            
        tableView.rx.itemDeselected
            .subscribe(onNext: { [unowned self] indexPath in
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .none
                }
            })
            .disposed(by: disposeBag)
    }

    // 커스텀 메소드
    @objc func didTapScrollView() {
        self.view.endEditing(true)
    }
}
