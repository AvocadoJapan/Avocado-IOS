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
        modalPresentationStyle = .fullScreen
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
                
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
//        navigationBar.isHidden = true
//        navigationBar.backI-ndicatorImage = UIImage(named: "back_button")
//        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back_button")
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
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
