//
//  ProfileSettingVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/04.
//

import Foundation
import UIKit
import RxSwift
import Amplify
import RxRelay
import PhotosUI

class ProfileSettingVM {
    
    var selectedImageSubject = BehaviorSubject<UIImage>(value: UIImage(named: "default_profile") ?? UIImage())
    let disposeBag = DisposeBag()
    
}

