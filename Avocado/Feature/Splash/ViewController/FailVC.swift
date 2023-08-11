import Foundation
import UIKit
import Then
import RxSwift
import RxFlow
import RxCocoa
import RxRelay

final class FailVC: BaseVC {
    
    var errorText: String
    
    lazy var titleLabel = UILabel().then {
        $0.text = "Error Occurred"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    lazy var errorLabel = UILabel().then {
        $0.text = errorText
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .systemGray4
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    lazy var retryButton = UIButton().then {
//        $0.configuration = .plain()
        $0.setTitle("Retry", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemGray4, for: .highlighted)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
    }

    
    init(error: NetworkError = NetworkError.unknown(-500, "unknown error")) {
        self.errorText = error.errorDescription 
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setProperty() {
        view.backgroundColor = .black
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setLayout() {
        [titleLabel, errorLabel, retryButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        errorLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(errorLabel.snp.top).offset(-10)
        }
        
        retryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(errorLabel.snp.bottom).offset(10)
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
