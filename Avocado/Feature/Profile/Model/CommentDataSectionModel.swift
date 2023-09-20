//
//  CommentDataSectionModel.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/20.
//
import Differentiator

import Foundation
struct CommentListDataSection {
    var header: String?
    var items: [Comment.DTO]
}

extension CommentListDataSection: SectionModelType {
    typealias Item = Comment.DTO

    init(original: CommentListDataSection, items: [Comment.DTO]) {
        self = original
        self.items = items
    }
}
