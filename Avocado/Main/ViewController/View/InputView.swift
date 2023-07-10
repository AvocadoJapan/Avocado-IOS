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
    
    private var labelString : String
    
    private var placeholder: String
    
    var rightLabelString = BehaviorRelay<String>(value: "")
    
    var userInput = BehaviorRelay<String>(value: "")
    
    private var regSetting: RegVarient?
    
    private let disposeBag = DisposeBag()
    
    private lazy var textField = UITextField().then {
        $0.placeholder = self.placeholder
        $0.font = .systemFont(ofSize: 13)
        $0.layer.cornerRadius = 10
        $0.contentVerticalAlignment = .center
        $0.tintColor = .black
    }
    
    private lazy var leftLabel = UILabel().then {
        $0.text = self.labelString
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    private lazy var rightLabel = UILabel().then {
        //        $0.text = self.rightLabelString.value
        $0.text = "여기에 상호작용 메세지"
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .systemRed
    }
    
    override init(frame: CGRect) {
        self.labelString = ""
        self.placeholder = ""
        self.regSetting = nil
        super.init(frame: .zero)
    }
    
    convenience init(label : String,
                     placeholder : String = "",
                     bgColor : UIColor = .white,
                     colorSetting : ColorVariant = .normal,
                     regSetting: RegVarient? = nil,
                     passwordable: Bool = false) {
        self.init(frame: .zero)
        
        self.labelString = label
        self.placeholder = placeholder
        self.textField.isSecureTextEntry = passwordable
        self.regSetting = regSetting
        self.leftLabel.textColor = colorSetting.textColor
        self.textField.backgroundColor = colorSetting.bgColor
        
        rightLabelString
            .bind(to: rightLabel.rx.text)
            .disposed(by: disposeBag)
        

        textField
            .rx
            .controlEvent(.editingDidEnd)
            .withLatestFrom(textField.rx.text.orEmpty)
            .map { [weak self] text -> String in
                guard let rules = self?.regSetting?.rules else {
                    return ""
                }

                for rule in rules {
                    if !rule.check(text) {
                        return rule.errorMessage
                    }
                }

                return ""
            }
            .bind(to: rightLabelString)
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
        self.regSetting = nil
        super.init(coder: coder)
    }
    
    func buildStackView() -> UIStackView {
        
        
        let textFieldBackground = UIView().then {
            $0.addSubview(self.textField)
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 10
        }
        
        lazy var labelStackView = UIStackView().then {
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            $0.isLayoutMarginsRelativeArrangement = true

            $0.addArrangedSubview(leftLabel)
            $0.addArrangedSubview(rightLabel)
        }
        
        let wapperView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.addArrangedSubview(labelStackView)
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
}
