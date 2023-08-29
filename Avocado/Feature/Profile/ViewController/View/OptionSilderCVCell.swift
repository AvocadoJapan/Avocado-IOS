//
//  OptionSilderCVCell.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import UIKit

final class OptionSilderCVCell: UICollectionViewCell {

    static var identifier = "OptionSilderCVCell"
    
    lazy var titleLabel = UILabel().then {
        $0.text = "구매 10"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperty()
        setLayout()
        setConstarint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperty() {
        backgroundColor = .black
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    private func setLayout() {
        addSubview(titleLabel)
    }
    
    private func setConstarint() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public func configure(title: String) {
        titleLabel.text = title
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct OptionSilderCVCellPreview:PreviewProvider {
    static var previews: some View {
        return OptionSilderCVCell(frame: .zero).toPreview().previewLayout(.fixed(width: 100, height: 35))
    }
}
#endif
