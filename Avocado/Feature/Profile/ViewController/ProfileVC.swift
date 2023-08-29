//
//  ProfileVC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import UIKit
import RxDataSources

final class ProfileVC: BaseVC {
    
    private lazy var collectionFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionFlowLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(
            ProfileHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderReusableView.identifier
        )
        
        $0.register(
            ProductCVCell.self,
            forCellWithReuseIdentifier: ProductCVCell.identifier)
        
        $0.register(
            OptionSilderCVCell.self,
            forCellWithReuseIdentifier: OptionSilderCVCell.identifier)
    }
    
    let viewModel: ProfileVM
    
    init(viewModel: ProfileVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.actionViewDidLoad.accept(())
    }
    
    override func setLayout() {
        view.addSubview(collectionView)
    }
    
    override func setConstraint() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        collectionView.delegate = self
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<UserProfileDataSection> { dataSource, collectionView, indexPath, item in
            switch item {
            case .slider(let title):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionSilderCVCell.identifier, for: indexPath) as! OptionSilderCVCell
                cell.configure(title: title)
                return cell

            case .buyed(let product):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVCell.identifier, for: indexPath) as! ProductCVCell
                cell.config(product: product)
                return cell

            case .selled(let product):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVCell.identifier, for: indexPath) as! ProductCVCell
                cell.config(product: product)
                return cell
            }
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in

            switch indexPath.section {
            case 0:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderReusableView.identifier, for: indexPath) as! ProfileHeaderReusableView
                let data = dataSource[indexPath.section]

                headerView.configure(userName: data.userName ?? "",
                                     grade: data.userGrade ?? "",
                                     verified: data.userVerified ?? "",
                                     creationDate: data.creationDate ?? "")
                return headerView

            default:
                return UICollectionReusableView()
            }
        }
        
        output.successProfileEventDateSourcePublish
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 70, height: 35)
        default:
            let width = view.safeAreaLayoutGuide.layoutFrame.width / 3 - 10
            return CGSize(width: width, height: 220)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if case 0 = section {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        
        return .zero
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProfileVCPreview: PreviewProvider {
    static var previews: some View {
        return UINavigationController(
            rootViewController: ProfileVC(
                viewModel: ProfileVM(
                    service: ProfileService()
                )
            )
        ).toPreview()
    }
}
#endif
