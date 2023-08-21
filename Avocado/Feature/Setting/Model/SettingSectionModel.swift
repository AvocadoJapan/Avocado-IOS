//
//  SettingSectionModel.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/08.
//

import Differentiator

/**
 * - Description 설정 정적 데이터 모델
 */
struct SettingData {
    let title: String // 제목
    let imageName: String /// 이미지 여부 `isEmpty`일 경우 이미지가 보이지 않음
    let type: SettingType // 설정 타입
    
    init(title: String, imageName: String = "", type: SettingType) {
        self.title = title
        self.imageName = imageName
        self.type = type
    }
}
/**
 * - Description 설정 타입 정보 셀에 대한 행동 정보를 담음
 */
enum SettingType {
    case syncSocial(type: SocialType)
    case userLogOut
    case deleteAccount
}

/**
 * - Description RxDataSource를 이용하기 위한 섹션 헤더 제목과 아이템들
 */
struct SettingDataSection {
    var title: String // 섹션 헤더 제목
    var items: [SettingData]
}

extension SettingDataSection: SectionModelType {
    typealias Item = SettingData
    
    init(original: SettingDataSection, items: [SettingData]) {
        self = original
        self.items = items
    }
}
