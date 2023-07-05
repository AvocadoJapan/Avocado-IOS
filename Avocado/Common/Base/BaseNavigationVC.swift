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
        navigationBar.tintColor = .black
        navigationBar.barTintColor = .systemPink
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//        navigationBar.isHidden = true
//        navigationBar.backIndicatorImage = UIImage(named: "back_button")
//        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_button")
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
