//
//  SettingStep.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/31.
//
import RxFlow

@frozen enum SettingStep: Step {
    case settingIsRequired
    case settingIsComplete// FIXME: 케이스 명 변경가능성있음 설정화면을 나간 경우 {메인으로 이동}
    case errorOccurred(error: NetworkError) //에러가 발생했을 경우
}
