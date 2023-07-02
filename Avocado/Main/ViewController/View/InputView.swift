//
//  InputView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/24.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class InputView : UIView {
    
    var labelString : String
    
    var placeholder: String
    
    var userInput = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    
    lazy var textField = UITextField().then {
        $0.placeholder = self.placeholder
        $0.font = .systemFont(ofSize: 13)
        $0.layer.cornerRadius = 10
        $0.contentVerticalAlignment = .center
    }
    
    lazy var label = UILabel().then {
        $0.text = self.labelString
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    override init(frame: CGRect) {
        self.labelString = ""
        self.placeholder = ""
        super.init(frame: .zero)
        print(#fileID, #function, #line, "- ")
    }
    
    convenience init(label : String,
                     placeholder : String = "",
                     bgColor : UIColor = .white,
                     colorSetting : ColorVariant = .normal,
                     regSetting: regVarient? = nil,
                     passwordable: Bool = false) {
        self.init(frame: .zero)

        self.labelString = label
        self.placeholder = placeholder
        self.textField.isSecureTextEntry = passwordable
        
        self.label.textColor = colorSetting.textColor
        self.textField.backgroundColor = colorSetting.bgColor
        
        textField.rx.text
                    .orEmpty
                    .bind(to: userInput)
                    .disposed(by: disposeBag)
        
        //MARK: - UI 설정
        let stackView = buildStackView()
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        self.labelString = ""
        self.placeholder = ""
        super.init(coder: coder)
    }
    
    func buildStackView() -> UIStackView {
        

        let textFieldBackground = UIView().then {
            $0.addSubview(self.textField)
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 10
        }

        let wapperView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.addArrangedSubview(label)
            $0.addArrangedSubview(textFieldBackground)
        }
        
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
        textFieldBackground.snp.makeConstraints {
            $0.height.equalTo(50)
        }

        return wapperView
    }
    
    //    @objc func handleUserInput(_ sender: UITextField){
    //        print(#fileID, #function, #line, "- sender: \(String(describing: sender.text))")
    //        self.userInput.onNext(sender.text ?? "")
    //    }
    //
    //    func setUserInputAction(target: Any?, action: Selector){
    //
    //        self.textField.removeTarget(self, action: #selector(handleUserInput), for: .editingChanged)
    //
    //        self.textField.addTarget(target, action: action, for: .editingChanged)
    //    }
}
