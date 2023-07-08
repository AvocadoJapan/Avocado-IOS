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
    
    init(title: String, imageName: String = "") {
        self.title = title
        self.imageName = imageName
    }
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
