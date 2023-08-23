//
//  UINavigationController.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/19.
//

import UIKit

extension UINavigationController {

    func setupNavbar(with title: String, logoImage: UIImage?) {
        navigationBar.shadowImage = UIImage()
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        
        let logoImageView = UIImageView().then {
            $0.image = logoImage
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .black
        }
        
        let label = UILabel().then {
            $0.text = title
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 14, weight: .bold)
        }
        
        [logoImageView, label].forEach {
            logoContainer.addSubview($0)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
        let leftItem = UIBarButtonItem(customView: logoContainer)
        topViewController?.navigationItem.leftBarButtonItem = leftItem
    }
}
