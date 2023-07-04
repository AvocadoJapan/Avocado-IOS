//
//  UIView+Extension.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import Foundation

#if DEBUG && canImport(SwiftUI)
import SwiftUI
extension UIView {
    private struct UIViewPreview: UIViewRepresentable {
        typealias UIViewType = UIView
        
        let view: UIView
        
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }
    }
    
    func toPreview() -> some View {
        return UIViewPreview(view: self)
    }
}

#endif
