//
//  ProfileService.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import Foundation
import RxSwift

final class ProfileService: BaseAPIService<ProfileAPI> {
    
    func getProfilePage() -> Observable<UserProfileDTO> {
        return singleRequest(.userProfile, responseType: UserProfile.self).asObservable()
    }
}
