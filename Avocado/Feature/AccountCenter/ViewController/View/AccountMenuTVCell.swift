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
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "구글 연동하기"
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    private lazy var arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .black
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
        backgroundColor = .systemGray6
    }
    
    func setLayout() {
        [titleLabel, arrowImageView].forEach {
            addSubview($0)
        }
    }
    
    func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configCell(data: AccountCenterData) {
        titleLabel.text = data.type.title
        
        if data.type.isHighlight {
            titleLabel.textColor = .systemRed
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct AccountMenuTVCellPreview:PreviewProvider {
    static var previews: some View {
        return AccountMenuTVCell().toPreview().previewLayout(.fixed(width: 314, height: 50))
    }
}
#endif

