//
//  TabStep.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/31.
//

import RxFlow
import Foundation
import RxRelay
import RxSwift
import UIKit

enum TabType : Int{
    case home = 0
    case search = 1
    case upload = 2
    case chat    = 3
    case myPage = 4
    var tabBarItem : UITabBarItem {
        switch self {
        case .home : return UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        case .search : return UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        case .upload : return UITabBarItem(title: "업로드", image: UIImage(systemName: "plus.circle"), selectedImage: UIImage(systemName: "plus"))
        case .chat: return UITabBarItem(title: "채팅", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message"))
        case .myPage: return UITabBarItem(title: "프로필", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        }
    }
    var title : String {
        switch self {
        case .home: return "홈"
        case .search: return "즐겨찾기"
        case .upload: return "업로드"
        case .chat: return "채팅"
        case .myPage: return "프로필"
        }
    }
}


@frozen enum TabStep: Step {

    // 메인탭
    case mainTabIsRequired
    
    // 딥링크처리 추후 처리
    // case someScreenIsRequired
    
    // 에러처리
//    case errorOccurred(error: NetworkError)
}


