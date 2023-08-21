//
//  SplashStep.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/14.
//

// README
// Step들을 단순히 뷰 컨트롤러로 정의하는 것보다는, 더욱 고수준의 사용자 이벤트나 앱의 상태를 나타내는 것이 좋습니다.
// 이렇게 하면 뷰 컨트롤러의 순서나 이동 로직이 Step에 직접적으로 연결되지 않으므로, 앱의 네비게이션 로직을 더욱 유연하게 변경하거나 확장할 수 있습니다.
// 예를 들어, '로그인 화면을 표시'와 같은 Step 대신 '사용자가 로그인을 요청함'과 같은 Step을 고려해 보세요.
// 이런 방식으로 Step을 정의하면 앱의 네비게이션 로직이 뷰 컨트롤러의 구현 자체와는 독립적이게 되므로, 더 나은 재사용성과 테스트 가능성을 제공합니다.
// 물론, 실제 구현은 프로젝트의 요구 사항에 따라 달라질 수 있습니다.

import RxFlow
import Foundation
import RxRelay
import RxSwift


@frozen enum SplashStep: Step {
    
    // Loding
    case splashIsRequired
    case tokenIsRequired
    case tokenIsExist(user: User)
    case errorOccurred(error: NetworkError)
}
