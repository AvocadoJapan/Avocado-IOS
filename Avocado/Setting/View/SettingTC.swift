//
//  SettingTC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/08.
//

import UIKit
import Foundation

final class SettingTC: UITableViewCell {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        setLayout()
        setConstraint()
        bindUI()
    }
    
    func setLayout() {
        [titleLabel, settingImageView, arrowImageView].forEach {
            addSubview($0)
        }
    }
    
    func setConstraint() {
        settingImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(20)
            make.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(settingImageView.snp.right).offset(10)
            make.right.equalTo(arrowImageView.snp.left)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(10)
        }
    }
    
    func bindUI() {
        
    }
    
    private func setImageVisible(visible: Bool) {
        settingImageView.snp.updateConstraints { make in
            make.width.equalTo(visible ? 20 : 0)
        }
    }
    
    func configureCell(data: SettingData) {
        setImageVisible(visible: !data.imageName.isEmpty)
        
        titleLabel.text = data.title
        settingImageView.image = UIImage(named: data.imageName)
        
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct SettingTCPreview:PreviewProvider {
    static var previews: some View {
        return SettingTC().toPreview().previewLayout(.fixed(width: 414, height: 60))
    }
}
#endif
