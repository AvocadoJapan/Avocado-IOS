//
//  SettingService.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/06.
//

import Foundation
import RxSwift

final class SettingService: BaseAPIService<SettingAPI> {
    func socialSync(provider: SocialType, callBack:String) -> Observable<CommonModel.SingleURL> {
        return singleRequest(.auth(provider: provider, callback: callBack)).asObservable()
    }
}
