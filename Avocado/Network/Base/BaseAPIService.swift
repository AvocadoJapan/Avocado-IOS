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
    }
    
    
}
