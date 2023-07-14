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
    
    init(vm viewModel: RegionSettingVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 지역 정보 조회 API call
        viewModel.fetchRegion()
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }

    override func setLayout() {
        [tableView, titleLabel, searchBar, tableView, confirmButton].forEach {
            view.addSubview($0)
        }
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
        
        viewModel.regions
            .bind(to: tableView.rx.items(cellIdentifier: RegionTVCell.identifier, cellType: RegionTVCell.self)) { _, region, cell in
                cell.configure(with: region)
            }
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(Region.self)
            .subscribe(onNext: { [weak self] data in
                self?.viewModel.regionIdOb.accept(data.id)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .regionIdOb
            .map { $0.isEmpty ? .lightGray : .black }
            .bind(to: confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel
            .regionIdOb
            .map({ !$0.isEmpty })
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        confirmButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                let authService = AuthService()
                let profileVM = ProfileSettingVM(service: authService, regionid: self?.viewModel.regionIdOb.value ?? "")
                let profileVC = ProfileSettingVC(vm: profileVM)
                self?.navigationController?.pushViewController(profileVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                self.confirmButton.keyboardMovement(from: self.view, height: height)
            })
            .disposed(by: disposeBag)
    }

    // 커스텀 메소드
    @objc func didTapScrollView() {
        self.view.endEditing(true)
    }
    
    /**
     * - Description 현재 위치 주소를 가져오는 Observable
     * - Returns 현재 주소
     */
    private func getCurrentAddress() -> Observable<String> {
        return Observable.create { [weak self] observer in
            let geocoder = CLGeocoder()
            
            guard let location = self?.locationManager.location else {
                return Disposables.create()
            }
            
            geocoder.reverseGeocodeLocation(location) { placeMarks, err in
                if let err = err {
                    Logger.e(err)
                    return
                }
                
                guard let placemark = placeMarks?.first else {
                    return
                }
                
                var address = ""
                
                if let adminstrativeArea = placemark.administrativeArea {
                    address = "\(adminstrativeArea)"
                }
                
                if let locality = placemark.locality {
                    address.append(locality)
                }
                
                if let thoroughfare = placemark.thoroughfare {
                    address.append(thoroughfare)
                }
            
                Logger.d(address)
                observer.onNext(address)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}