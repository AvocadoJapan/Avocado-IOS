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
//import PhotosUI

final class UploadVC: BaseVC {
    
    private let viewModel: UploadVM
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "상품 업로드"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
//        $0.delegate = self
    }
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private lazy var imageCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    private lazy var imageCV = UICollectionView(frame: .zero, collectionViewLayout: self.imageCVLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
//        $0.backgroundColor = .systemCyan
    }
    
    private lazy var inputStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var titleInput = InputView(label: "상품명 (필수)")
    private lazy var priceInput = InputView(label: "가격 (필수)")
    private lazy var descriptionInput = InputView(label: "상품설명 (임의)")
    
    private lazy var uploadButton = BottomButton(text: "업로드 하기", buttonType: .primary)
    
    
    //    let photos: [UIImage] = [UIImage(named: "demo_product_ipad")!]
    
    init(viewModel: UploadVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setLayout() {
        view.addSubview(scrollView)
        view.addSubview(uploadButton)
        scrollView.addSubview(stackView)
        
        [titleLabel, imageCV, inputStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [titleInput, priceInput, descriptionInput].forEach {
            inputStackView.addArrangedSubview($0)
        }
    }
    
    override func setProperty() {
        // imageCV delegate설정, 셀등록
        imageCV.delegate = self
        imageCV.dataSource = self
        imageCV.register(ImageCVCell.self, forCellWithReuseIdentifier: ImageCVCell.identifier)
    }
    
    override func setConstraint() {
        scrollView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(uploadButton.snp.top)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        imageCV.snp.makeConstraints {
            $0.height.equalTo(120)
            $0.horizontalEdges.equalToSuperview()
        }
        
        inputStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        uploadButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}

extension UploadVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVCell.identifier, for: indexPath) as! ImageCVCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

extension UploadVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct UploadVCPreview: PreviewProvider {
    static var previews: some View {
        return UploadVC(viewModel: UploadVM(service: UploadService())).toPreview()
    }
}
#endif
