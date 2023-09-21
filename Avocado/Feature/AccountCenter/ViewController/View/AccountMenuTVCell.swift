//
//  AccountMenuTVCell.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/21.
//

import UIKit
import Foundation
import RxSwift

final class AccountMenuTVCell: UITableViewCell, TableCellIdentifierable {
    typealias T = AccountCenterData
    static var identifier: String = "AccountMenuCVCell"
    
    var disposeBag = DisposeBag()
    
    private lazy var titleLabel = UILabel().then { label in
        label.text = "구글 연동하기"
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
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
        setProperty()
        setLayout()
        setConstraint()
    }
    
    func setProperty() {
        selectionStyle = .none
    }
    
    func setLayout() {
        [titleLabel, arrowImageView].forEach {
            addSubview($0)
        }
    }
    
    func setConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(data: AccountCenterData) {
        titleLabel.text = data.title
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct AccountMenuTVCellPreview:PreviewProvider {
    static var previews: some View {
        return AccountMenuTVCell().toPreview().previewLayout(.fixed(width: 414, height: 50))
    }
}
#endif

