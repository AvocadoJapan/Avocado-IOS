import Foundation
import UIKit
import Then
import RxSwift
import RxFlow
import RxCocoa
import RxRelay

final class FailVC: BaseVC {
    
    var errorText: String
    
    lazy var errorLabel = UILabel().then {
        $0.text = errorText
        $0.textAlignment = .center
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    init(error: NetworkError = NetworkError.unknown(-500, "unknown error")) {
        self.errorText = error.errorDescription 
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setProperty() {
        view.backgroundColor = UIColor(hexCode: "085E05")
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setLayout() {
        view.addSubview(errorLabel)
    }
    
    override func setConstraint() {
        errorLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
        }
    }
}


#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct FailVCPreview: PreviewProvider {
    static var previews: some View {
        return FailVC().toPreview().ignoresSafeArea()
    }
}
#endif
