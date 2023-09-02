//
//  UITextField+Animation.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/22.
//
import UIKit
extension UIView {
    /**
     * - description 화면 shake 애니메이션
     */
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.08, 0.24, 0.415, 0.5]
        animation.duration = 0.5
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        self.layer.add(animation, forKey: nil)
    }
    
    /**
     * - description 화면 fadeOut 애니메이션
     */
    func fadeOut() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        layer.add(transition, forKey: kCATransition)
    }
}
