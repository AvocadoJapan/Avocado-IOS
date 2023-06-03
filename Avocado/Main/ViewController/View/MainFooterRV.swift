//
//  MainFooterRV.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit

final class MainFooterRV: UICollectionReusableView {
    static var identifier = "MainFooterRV"
    
    lazy var moreButton = UIButton().then {
        $0.setTitle("More", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(moreButton)
        
        moreButton.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init Error")
    }
        
}
#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct MainFooterRVPreview:PreviewProvider {
    static var previews: some View {
        return MainFooterRV().toPreview().previewLayout(.fixed(width: 414, height: 56))
    }
}
#endif
