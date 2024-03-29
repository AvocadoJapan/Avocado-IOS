//
//  MainCategoryCC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import RxSwift
import RxFlow
import RxRelay
import RxCocoa
/**
 * ##화면 명: 메인화면 카테고리 셀
 */

// 정적인 데이터기 때문에 Identifiable 프로토콜 채택 안함

final class MainSubMenuCVCell: UICollectionViewCell {
    static var identifier: String = "MainSubMenuCVCell"
    
    private var imageName: String = ""
    private var title: String = ""
    private var navigateTo: String = ""
    
    private lazy var iconImageView = UIImageView().then {
        $0.tintColor = .darkText
        $0.image = UIImage(named: "\(imageName)")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.text = "\(title)"
        $0.font = .systemFont(ofSize: 11, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .darkText
        $0.numberOfLines = 0 // 라벨이 필요한 만큼의 라인 수를 사용하도록 설정
        $0.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        //setLayout
        [iconImageView, nameLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        self.addSubview(stackView)
        
        // setConstraint
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(5)
        }
        
        iconImageView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(iconImageView.snp.width) // 높이를 너비와 같게 설정
        }
    }
    
    func configure(imageName: String, title: String, navigateTo: String) {
           self.imageName = imageName
           self.title = title
           self.navigateTo = navigateTo
           
           // 이미지와 라벨을 업데이트
           self.iconImageView.image = UIImage(named: imageName)
           self.nameLabel.text = title
       }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct MainSubMenuCVCellPreview:PreviewProvider {
    static var previews: some View {
        return MainSubMenuCVCell().toPreview().previewLayout(.fixed(width: 60, height: 75))
    }
}
#endif
