//
//  UploadVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/30.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then
import PhotosUI
import RxDataSources
import RxKeyboard

final class UploadVC: BaseVC {
    
    private let viewModel: UploadVM
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        //        $0.contentInsetAdjustmentBehavior = .never
        //        $0.delegate = self
    }
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var imageStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private lazy var photoDescriptionView = UIView()
    
    private lazy var photoUploadButton = UIButton().then {
        $0.setTitle("사진 업로드", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 14
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        
        $0.addTarget(self, action: #selector(handlePhotoUploadButton), for: .touchUpInside)
    }
    
    private lazy var photoLabel: UILabel = UILabel().then {
        $0.text = "사진 (필수)"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        $0.textColor = .darkGray
    }
    
    private lazy var photoDescriptionLabel: UILabel = UILabel().then {
        $0.text = "사진을 업로드 해주세요"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        $0.textColor = .lightGray
        $0.isHidden = false
    }
    
    
    private lazy var imageCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    private lazy var imageCV = UICollectionView(frame: .zero, collectionViewLayout: self.imageCVLayout).then {
        $0.showsHorizontalScrollIndicator = false
        
        //        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var inputStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var badgeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var badgeLabel: UILabel = UILabel().then {
        $0.text = "배지 (선택)"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        $0.textColor = .darkGray
    }
    
    private lazy var unusedBadgeView = UploadBadgeView(type: .unused)
    private lazy var avocadoPayBadgeView = UploadBadgeView(type: .avocadoPay)
    private lazy var fastShippingBadgeView = UploadBadgeView(type: .fastShipping)
    private lazy var freeShippingBadgeView = UploadBadgeView(type: .freeShipping)
    private lazy var refundableBadgeView = UploadBadgeView(type: .refundable)
    
    private lazy var titleInput = InputView(label: "상품명 (필수)", placeholder: "모자, 신발 등")
    private lazy var priceInput = InputView(label: "가격 (필수)", placeholder: "3,000원 이상")
    
    private lazy var descriptionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var descriptionLabel: UILabel = UILabel().then {
        $0.text = "설명 (선택)"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        $0.textColor = .darkGray
    }
    
    private lazy var descriptionView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .systemGray6
    }
    
    private lazy var descriptionTextView = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.tintColor = .black
        $0.textAlignment = .left
        $0.isScrollEnabled = true
        $0.autocorrectionType = .no
        
        $0.backgroundColor = .clear
    }
    
    private lazy var uploadButton = BottomButton(text: "업로드 하기", buttonType: .primary)
    
    private lazy var legalView = LegalView()
    
    init(viewModel: UploadVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        uploadButton
            .rx
            .tap
            .subscribe { [weak self] _ in
                self?.descriptionTextView.resignFirstResponder()
                SPIndicator.present(title: "시스템 에러", message: "지원하지 않는 기능", preset: .error, haptic: .error)
            }
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<ImageDataSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVCell.identifier, for: indexPath) as! ImageCVCell
                
                cell.delegate = self
                cell.config(image: item, indexPath: indexPath.row)
                
//                Logger.d("\(indexPath.row)")
//
//                cell.xButton
//                    .rx
//                    .tap
//                    .map {
//                        return  indexPath.row }
//                    .debug("map")
//                    .bind(to: self.viewModel.input.removeImageAtIndexRelay)
//                    .disposed(by: DisposeBag())
    
                return cell
            }
        )
        
        output.imageRelay
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] image in
                // 이미지 배열이 비어있으면 photoDescriptionLabel 을 표시합니다
                self?.photoDescriptionLabel.isHidden = !(image.first?.items == [])
            })
            .bind(to: imageCV.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // scrollView에 탭이 감지되면 키보드를 내립니다
        let tapGesture = UITapGestureRecognizer()
        scrollView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
    
    override func setProperty() {
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "상품업로드"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkText]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkText]
            navBarAppearance.backgroundColor = .white
            navBarAppearance.shadowColor = .white
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
        // imageCV셀등록
        imageCV.register(ImageCVCell.self, forCellWithReuseIdentifier: ImageCVCell.identifier)
    }
    
    override func setLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(photoDescriptionLabel)
        
        photoDescriptionView.addSubview(photoLabel)
        photoDescriptionView.addSubview(photoUploadButton)
        
        descriptionView.addSubview(descriptionTextView)
        
        [photoDescriptionView, imageStackView, inputStackView, badgeStackView, descriptionStackView, legalView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [photoDescriptionView, imageCV].forEach {
            imageStackView.addArrangedSubview($0)
        }
        
        [descriptionLabel, descriptionView, uploadButton].forEach {
            descriptionStackView.addArrangedSubview($0)
        }
        
        [titleInput, priceInput].forEach {
            inputStackView.addArrangedSubview($0)
        }
        
        [badgeLabel, unusedBadgeView, avocadoPayBadgeView, fastShippingBadgeView, freeShippingBadgeView, refundableBadgeView].forEach {
            badgeStackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraint() {
        // 스크롤뷰 제약 조건 설정
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // 스택뷰 제약 조건 설정
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width) // 스택뷰의 너비는 스크롤뷰와 같게
        }
        
        photoDescriptionView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.horizontalEdges.equalToSuperview()
        }
        
        photoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        }
        
        photoUploadButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(100)
        }
        
        imageCV.snp.makeConstraints {
            $0.height.equalTo(120)
        }
        
        [unusedBadgeView,avocadoPayBadgeView, fastShippingBadgeView, freeShippingBadgeView, refundableBadgeView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }
        
        descriptionView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        photoDescriptionLabel.snp.makeConstraints {
            $0.center.equalTo(imageCV)
        }
    }
}

extension UploadVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        viewModel.input.imageRelay.accept(results)
    }
    
    @objc func handlePhotoUploadButton() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 8
        configuration.filter = .images
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true)
    }
}

extension UploadVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension UploadVC: AvocadoCellTapDelegate {
    func touchEvent(indexPath: Int) {
        self.viewModel.input.removeImageAtIndexRelay.accept(indexPath)
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
import SPIndicator
struct UploadVCPreview: PreviewProvider {
    static var previews: some View {
        return UploadVC(viewModel: UploadVM(service: UploadService())).toPreview()
    }
}
#endif
