//
//  UIViewController+Extension.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import Foundation

#if DEBUG && canImport(SwiftUI)
import SwiftUI
extension UIViewController {
    private struct ViewControllerPreview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
    
    func toPreview() -> some View {
        return ViewControllerPreview(viewController: self)
    }

}
#endif
