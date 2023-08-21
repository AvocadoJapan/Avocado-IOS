//
//  BaseS3Service.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/04.
//

import Foundation
import RxSwift
import Moya

/**
 * - Description S3 버킷에 업로드할 서비스 클래스로 사용
 */
final class S3Service: BaseAPIService<S3Target> {
    /**
     *  - Description S3 버킷 파일 업로드 메서드
     *  - parameter requestURL: Server에서 전달받은 presigned URL
     *  - parameter uploadData: 파일 업로드 객체
     *  - parameter parameter: Server에서 전달받은 파라미터 객체 { S3의 경우 이 파라미터를 가지고 업로드를 해야지만 정상 업로드가 됨 }
     *  - returns 업로드 성공 여부 (204: 성공)
     */
    func uploadS3(requestURL: String, uploadData: Data, parameter: [String: String]) -> Single<Bool> {
        return singleRequest(.upload(requestURL: requestURL, uploadData: uploadData, param: parameter))
    }
}

//MARK: - S3Target Enum
/**
 * - Description S3 버킷에 업로드할 Moya 타겟 정보
 */
@frozen
enum S3Target {
    // s3에 업로드할 presigned URL, 파일 업로드 객체, s3 버킷 업로드에 필요한 파라미터 객채
    case upload(requestURL: String, uploadData: Data, param: [String: String])
}

extension S3Target: BaseTarget {
    // 헤더의 경우 멀티파트로 진행
    var headers: [String : String]? {
        return ["Content-Type": "multipart-form/data"]
    }
    
    // presigned URL을 서버에서 전달해주기 때문에 baseURL을 동적으로 설정
    var baseURL: URL {
        switch self {
        case .upload(let url, _, _):
            return URL(string: url)!
        }
    }
    
    // 추가적인 엔드포인트가 없기 때문에 path 값을 공란으로 입력
    var path: String {
        return ""
    }
    
    // s3업로드의경우 multipart/form-data의 post 형식으로 진행되기 때문에 HTTP method를 post로 설정
    var method: Moya.Method {
        return .post
    }
    
    // 멀티 파트객체 설정
    var task: Task {
        switch self {
        case .upload(_, let data, let param):
            var multipartData = [MultipartFormData]()
            
            // API에서 전달받은 파라미터 객체를 멀티파트 객체 데이터로 변환, 이때 데이터 형식을 `Data` 형식으로 보냄
            for (key, value) in param {
                let formData = MultipartFormData(provider: .data(value.data(using: .utf8)!), name: key)
                multipartData.append(formData)
            }
            
            // 이미지 데이터를 가장 마지막에 보내야함, 키값을 `file`로 고정
            let imageData = MultipartFormData(provider: .data(data), name: "file", fileName: "user-upload-image-\(data.count).jpeg", mimeType: "image/jpeg")
            multipartData.append(imageData)
            
            return .uploadMultipart(multipartData)
        }
    }
    
    var authorizationType: AuthorizationType? {
        return .none
    }
}

