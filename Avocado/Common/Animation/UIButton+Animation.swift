//
//  UIButton+Annimation.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/04.
//

import Foundation
import UIKit

extension UIButton {
    func keyboardMovement(from view: UIView, height: CGFloat, updateValue: CGFloat = 20) {
        let updateHeight = height > 0 ? height - view.safeAreaInsets.bottom : updateValue
        let constraint = height > 0 ? 0 : updateValue

        UIView.animate(withDuration: 2.0) {
            self.snp.updateConstraints {
                $0.leading.equalToSuperview().inset(constraint)
            }

            self.layer.cornerRadius = constraint
        }

        UIView.animate(withDuration: 0) {
            self.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(updateHeight)
            }
        }

        view.layoutIfNeeded()
    }
}

