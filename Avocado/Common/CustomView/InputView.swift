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

final class InputView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    private var labelString : String
    
    private var placeholder: String
    
    var rightLabelString = BehaviorRelay<String>(value: "")
    
    var userInput = PublishRelay<String>()
    // 정규식 유효성 여부 Observable (기본적으로 false)
    var isVaild = BehaviorRelay<Bool>(value: false)
    
    private var regSetting: RegVarient?
    
    private let disposeBag = DisposeBag()
    
    private lazy var textField: UITextField = UITextField().then {
        $0.placeholder = self.placeholder
        $0.font = .systemFont(ofSize: 13)
        $0.layer.cornerRadius = 10
        $0.contentVerticalAlignment = .center
        $0.borderStyle = .none
        $0.autocorrectionType = .no
        
        $0.delegate = self
    }
    
    private lazy var leftLabel: UILabel = UILabel().then {
        $0.text = self.labelString
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    private lazy var rightLabel: UILabel = UILabel().then {
        $0.text = "여기에 상호작용 메세지"
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .systemRed
    }
    
    private let textFieldBackground: UIView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 10
    }
    
    private let labelStackView: UIStackView = UIStackView().then {
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private let wrapperView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
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
                     passwordable: Bool = false,
                     keyboardType: UIKeyboardType = .default) {
        self.init(frame: .zero)
        
        self.labelString = label
        self.placeholder = placeholder
        self.textField.isSecureTextEntry = passwordable
        self.regSetting = regSetting
        self.textField.keyboardType = keyboardType
        
        rightLabelString
            .bind(to: rightLabel.rx.text)
            .disposed(by: disposeBag)
    
        textField
            .rx
            .text
            .orEmpty
            .filter({ [weak self] text in
                // 텍스트 입력을 하지 않은 경우 userinput에 값을 보내지 않음
                guard !text.isEmpty else {
                    return false
                }
                
                var isValid = true
                
                // 정규식 유효성
                if let rules = self?.regSetting?.rules {
                    for rule in rules {
                        if !rule.check(text) {
                            self?.rightLabelString.accept(rule.errorMessage)
                            self?.isVaild.accept(false)
                            isValid = false
                            break
                        }
                    }
                    
                    // 정규식 유효성 검사에 통과된 경우 에러메시지 초기화 및 isVaild true
                    if isValid {
                        self?.rightLabelString.accept("") // 에러 메시지를 초기화
                        self?.isVaild.accept(true)
                    }
                }
                
                return isValid
            })
            .bind(to: userInput)
            .disposed(by: disposeBag)
        
        isVaild
            .distinctUntilChanged()
            .filter { !$0 }
            .subscribe(onNext: { [weak self] _ in
                self?.playShakeAnimation()
            })
            .disposed(by: disposeBag)
        
        rightLabelString
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                if !text.isEmpty {
                    self?.textFieldBackground.layer.borderColor = UIColor.systemRed.cgColor
                    self?.textFieldBackground.layer.borderWidth = 1

                    self?.textField.tintColor = .systemRed
                    self?.textField.textColor = .systemRed
                    
                    self?.leftLabel.textColor = .systemRed
                } else {
                    self?.textFieldBackground.backgroundColor = colorSetting.bgColor
                    self?.textFieldBackground.layer.borderWidth = 0
                    
                    self?.leftLabel.textColor = colorSetting.textColor
                    
                    self?.textField.tintColor = .black
                    self?.textField.textColor = .black
                }
            })
            .disposed(by: disposeBag)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.labelString = ""
        self.placeholder = ""
        self.regSetting = nil
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.addSubview(wrapperView)
        
        labelStackView.addArrangedSubview(leftLabel)
        labelStackView.addArrangedSubview(rightLabel)
        
        textFieldBackground.addSubview(textField)
        
        wrapperView.addArrangedSubview(labelStackView)
        wrapperView.addArrangedSubview(textFieldBackground)
    }
    
    private func setupConstraints() {
        wrapperView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        textFieldBackground.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }

        textFieldBackground.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    /**
     * - Description 키보드 hidden 메서드
     */
    public func keyboardHidden() {
        textField.resignFirstResponder()
    }
    
    /**
     * - Description emailAddress일 경우 대문자 입력방지 델리게이트 메소드
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .emailAddress {
            let lowercasedString = string.lowercased()
            
            if string != lowercasedString {
                if let text = textField.text, let textRange = Range(range, in: text) {
                    textField.text = text.replacingCharacters(in: textRange, with: lowercasedString)
                }
                return false
            }
        }
        return true
    }
    
    /**
     * - Description 텍스트 필드 흔들기 애니메이션 실행
     */
    public func playShakeAnimation() {
        textField.shake()
    }
}
