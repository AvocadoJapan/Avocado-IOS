//
//  UIImage+Extension.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/05.
//

import Foundation
import UIKit


extension UIImage {
    /**
     * - description 이미지 리사이징 메서드
     * - parameter width: 이미지 가로 크기 px
     */
    func resize(width: CGFloat) -> UIImage {
        let scale = width/self.size.width
        let height = self.size.height * scale
        
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            return self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}
