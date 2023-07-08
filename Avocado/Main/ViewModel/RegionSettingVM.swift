//
//  RegionSettingVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class RegionSettingVM {
    var textOb = BehaviorRelay<String>(value: "")
    
    let disposeBag = DisposeBag()
}
