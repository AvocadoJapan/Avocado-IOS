//
//  MainHeaderRV.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit

final class MainHeaderRV: UICollectionReusableView {
    static var identifier = "MainHeaderRV"
    
    lazy var titleLabel = UILabel().then {
        $0.text = """
                    もふもふの
                    お友達
                    """
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.numberOfLines = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.bottom.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init Error")
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct MainHeaderRVPreview:PreviewProvider {
    static var previews: some View {
        return MainHeaderRV().toPreview().previewLayout(.fixed(width: 414, height: 56))
    }
}
#endif
