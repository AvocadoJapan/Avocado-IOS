//
//  APIRequestInterceptor.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/20.
//

import Foundation
import Alamofire
import Moya
import RxSwift
import RxMoya

/**
 * - Description: API인증 처리 중 401 인증오류가 발생하였을 때 토큰 갱신하여 처리해줄 Interceptor 클래스
 */
final class APIRequestInterceptor: RequestInterceptor {
    
    let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // 토큰 갱신처리.. ing
        let authService = AuthService()
        authService.retryAuthToken()
            .subscribe { _ in
                Logger.d("Token 갱신 진행")
                completion(.retry)
            } onError: {
                completion(.doNotRetryWithError($0))
            }
            .disposed(by: disposeBag)

    }
}

