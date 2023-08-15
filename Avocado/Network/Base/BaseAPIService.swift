//
//  BaseAPIService.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/20.
//

import Foundation
import RxMoya
import Moya
import RxSwift

/**
 * - Description: APIRequest를 위한 MoyaProvider와 request함수를 제공해주는 BaseAPIService
 */
class BaseAPIService<Target: BaseTarget> {
    var provider: MoyaProvider<Target>
    
    /**
     * - Description : BaseAPIService에서 테스트코드를 위한 이니셜라이저
     * - Parameter isSutub 테스트 여부 {테스트 용 인지} 기본값으로는 `false`
     * - Parameter sampleStatusCode HTTPStatusCode값 기본값으로는 `200`
     * - Parameter customEndPointClosure  엔드포인트에 대한 클로저 함수 기본값은 `nil`
     */
    init(isStub: Bool = false, sampleStatusCode: Int = 200, customEndPointClosure: ((Target) -> Endpoint)? = nil) {
        if (!isStub) {
            // accessToken Setting
            let authPlugin = AccessTokenPlugin { _ in
                guard let accessToken = KeychainUtil.loginAccessTokenRead() else {
                    return ""
                }
                return accessToken
            }
            
            // networklogger Setting
            let loggerPlugin = NetworkLoggerPlugin()
            let interceptor = APIRequestInterceptor()
            let session = Session(interceptor: interceptor)
            
            provider = MoyaProvider<Target>(session: session, plugins: [loggerPlugin, authPlugin])
        }
        else {
            let endPointClosure = { (target:Target) -> Endpoint in
                let smapleResponseClosure: () -> EndpointSampleResponse = {
                    EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
                }
                
                return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: smapleResponseClosure,
                                method: target.method, task: target.task,
                                httpHeaderFields: target.headers)
                
            }
            
            provider = MoyaProvider<Target>(endpointClosure: customEndPointClosure ?? endPointClosure,
                                            stubClosure: MoyaProvider.immediatelyStub)
        }
    }
    
    /**
     * - Description: 페이징이 필요한 HTTP Request + DTO변환이 필요한 Request 메서드
     * - Parameter type: APITarget
     * - Parameter responseType: HTTP Request시 디코딩할 객체 타입
     * - Returns Single로 Wrapping + BasePagenationResponse객체로 Wrapping한 Response 객체의 DTO 배열 객체
     */
    func pagingRequest<D: DTOResponseable>(_ type: Target, responseType: D.Type) -> Single<BasePagenationResponse<[D.DTO]>> {
        return provider
            .rx
            .request(type)
            .timeout(.seconds(30), scheduler: MainScheduler.instance)
            .filterSuccessfulStatusCodes()
            .map(BasePagenationResponse<[D]>.self)
            .map {
                let dtoList = $0.items.map { $0.toDTO() }
                return BasePagenationResponse(nextToken: $0.nextToken, items: dtoList)
            }
            .catch { throw self.networkErrorHandling(error: $0) }
    }
    
    /**
     * - Description: 페이징이 필요한 HTTP Request에 대한 Request메서드
     * - Parameter type: APITarget
     * - Returns: Single로 Wrapping + BasePagenationResponse객체로 Wrapping한 Response 배열 객체
     */
    func pagingRequest<D: Decodable>(_ type: Target) -> Single<BasePagenationResponse<[D]>> {
        return provider
            .rx
            .request(type)
            .timeout(.seconds(30), scheduler: MainScheduler.instance)
            .filterSuccessfulStatusCodes()
            .map(BasePagenationResponse<[D]>.self)
            .catch { throw self.networkErrorHandling(error: $0) }
    }
    
    /**
     * - Description : DTO변환이 필요하지 않은 객체의 HTTP Request 메서드
     * - Parameter type: API Target
     * - Returns: Single로 Wrapping한 Response객체
     */
    func singleRequest<D: Decodable>(_ type: Target) -> Single<D> {
        return provider
            .rx
            .request(type)
            .timeout(.seconds(30), scheduler: MainScheduler.instance)
            .filterSuccessfulStatusCodes()
            .map(D.self)
            .catch { throw self.networkErrorHandling(error: $0) }
    }
    
    /**
     * - Description : response body가 필요없는 statusCode만으로 처리가능한 request 처리함수
     * - Parameter type: API Target
     * - Returns: statusCode가 200~299인경우 true 리턴
     */
    func singleRequest(_ type: Target) -> Single<Bool> {
        return provider
            .rx
            .request(type)
            .timeout(.seconds(30), scheduler: MainScheduler.instance)
            .flatMap{ response -> Single<Bool> in
                if (200...299) ~= response.statusCode {
                    return .just(true)
                }
                
                return .error(self.restAPIErrorHandling(code: response.statusCode,
                                                        message: response.description))
            }
    }
    /**
     * - Description: DTO 변환이 필요한 객체의 HTTP Request 메서드
     * - Parameter type: API Target
     * - Parameter responseType: HTTP Request시 디코딩할 객체 타입
     * - Returns: Single로 Wrapping한 Response의 DTO객체
     */
    func singleRequest<D: DTOResponseable>(_ type: Target, responseType: D.Type) -> Single<D.DTO> {
        return provider
            .rx
            .request(type)
            .timeout(.seconds(30), scheduler: MainScheduler.instance)
            .filterSuccessfulStatusCodes()
            .map(D.self)
            .map { $0.toDTO() }
            .catch { throw self.networkErrorHandling(error: $0) }
    }
    
    /**
     * - Description 에러 관련 하여 `NetworkError` Enum 컨버팅 함수
     * - Returns NetworkError
     */
    private func networkErrorHandling(error: Error) -> NetworkError {
        guard let moyaError = error as? MoyaError else {
            return NetworkError.unknown(-1, error.localizedDescription)
        }
        
        guard let response = moyaError.response,
              let errDescription = moyaError.errorDescription else {
            return NetworkError.invalidURL
        }
        
        return restAPIErrorHandling(code: response.statusCode, message: errDescription)
    }
    
    /**
     * - Description REST API에서 발생된 statusCode를 가지고 `Network`Enum 컨버팅 함수
     * - Returns NetworkError
     */
    private func restAPIErrorHandling(code: Int, message: String) -> NetworkError {
        switch code {
        case 401:
            return NetworkError.tokenExpired
        case 404:
            return NetworkError.pageNotFound
        case 409:
            return NetworkError.serverConflict
        case 500:
            return NetworkError.serverError
        default:
            return NetworkError.unknown(code, message)
        }
    }
}
