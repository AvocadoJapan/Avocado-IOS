//
//  BaseNavigationVC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/02.
//

import UIKit
import Foundation

final class BaseNavigationVC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        modalPresentationStyle = .fullScreen
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
