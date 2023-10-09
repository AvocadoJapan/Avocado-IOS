//
//  SettingCVCell.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/08.
//

import UIKit
import Foundation

final class SettingCVCell: UICollectionViewCell {
    static let identifier = "SettingTC"
    
    private lazy var titleLabel = UILabel().then { label in
        label.text = "구글 연동하기"
        label.font = UIFont.systemFont(ofSize: 15)
    }
    
    private lazy var settingImageView = UIImageView().then { imageView in
        imageView.image = UIImage(named: "btn_google")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    private lazy var arrowImageView = UIImageView().then { imageView in
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .black
    }
    
    private lazy var underLineView = ContourView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        setLayout()
        setConstraint()
    }
    
    private func setLayout() {
        [titleLabel,
         settingImageView,
         arrowImageView,
         underLineView
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraint() {
        settingImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(settingImageView)
            $0.left.equalTo(settingImageView.snp.right).offset(10)
            $0.right.equalTo(arrowImageView.snp.left)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.right.equalToSuperview().inset(10)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setImageVisible(visible: Bool) {
        settingImageView.snp.updateConstraints { make in
            make.width.equalTo(visible ? 20 : 0)
        }
    }
    
    func configureCell(data: SettingData, type: SettingType) {
        setImageVisible(visible: !data.imageName.isEmpty)
        
        titleLabel.text = data.title
        
        // 이미지가 없으면 설정 하지 않음
        if (!data.imageName.isEmpty) {
            settingImageView.image = UIImage(named: data.imageName)
        }
        
        switch type {
        case .userLogOut, .deleteAccount:
            titleLabel.textColor = .red
        default:
            titleLabel.textColor = .black
        }
        
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct SettingTCPreview:PreviewProvider {
    static var previews: some View {
        return SettingCVCell()
            .toPreview()
            .previewLayout(
                .fixed(
                    width: 414,
                    height: 60
                )
            )
    }
}
#endif
