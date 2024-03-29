//
//  BaseVC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import SnapKit
import Then
import RxFlow
import RxSwift
import RxRelay
import RxCocoa

/**
 - Description: 베이스 VC로, 뷰컨트롤러에 사용되는 기본적인 메서드를 담고 있음 (ex. bind, configure...)
 */
class BaseVC: UIViewController, Stepper {
    
    let steps: PublishRelay<Step> = PublishRelay()
    
    let disposeBag = DisposeBag()

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        setProperty()
        setLayout()
        setConstraint()
        setViewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //MARK: - View Method
    /**
     - Description: RX에 대한 데이터 바인딩 메서드
     - Warning: RX데이터 바인딩만 사용할 것 (프로퍼티나 레이아웃 설정의 경우 다른 메서드 사용)
     ```
     override bindUI() {
       ObservableData.bind(하위뷰.rx.etc)
        .subscribe(...)
     }
     ```
     */
    public func bindUI() {}
    /**
     - Description: UIViewController에 사용될 프로퍼티 설정 메서드
     ```
     override setProperty() {
       view.backgroundColor = .red
     }
     ```
     */
    public func setProperty() {}
    /**
     - Description: UIViewController에 사용될 하위 View에 대한 메서드
     ```
     override setLayout() {
       addSubView(하위뷰)
     }
     ```
     */
    public func setLayout() {}
    /**
     - Description: UIViewController에 addSubView된 UIView들에 대한 오토레이아웃 설정 메서드
     ```
     override setConstraint() {
       하위뷰.snp.makeConstraint {...}
     }
     ```
     */
    public func setConstraint() {}
    /**
     - Description: 위 메서드 이외에 ViewDidLoad에서 수행하고 싶은 작업 추가
     ```
     override setConstraint() {
       하위뷰.snp.makeConstraint {...}
     }
     ```
     */
    public func setViewDidLoad() {}
    
    deinit {
        Logger.trace(String(describing: self))
    }
}
