//
//  CollectionView+Protocol.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import Foundation
import UIKit

protocol CollectionCellIdentifierable: UICollectionViewCell {
    static var identifier:String {get}
}

protocol CollectionViewLayoutable: AnyObject {
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout
}
