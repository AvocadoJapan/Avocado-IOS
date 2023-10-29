//
//  ProfileVC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/10/09.
//

import UIKit
import RxDataSources

final class ProfileVC: BaseVC {

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: getCompositionalLayout()
    )
    .then {
        $0.bounces = false
        $0.register(
            ProfileHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderReusableView.identifier
        )
        
        $0.register(
            SettingCVCell.self,
            forCellWithReuseIdentifier: SettingCVCell.identifier
        )
    }
    
    private let viewModel: ProfileVM
    
    init(viewModel: ProfileVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationColor(color: .black)
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
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SettingDataSection> { dataSource, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SettingCVCell.identifier,
                for: indexPath
            ) as! SettingCVCell
            
            // cell configure
            cell.configureCell(
                data: item,
                type: item.type
            )
            
            return cell
            
        } configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: ProfileHeaderReusableView.identifier,
                for: indexPath
            ) as! ProfileHeaderReusableView
            
            let data = dataSource[indexPath.section]
            
            if indexPath.section == 0 {
                headerView.profileImageControlViewTapObservable
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: {
                        self?.viewModel.steps.accept(ProfileStep.profileDetailIsRequired)
                    })
                    .disposed(by: headerView.disposeBag)
            }
            
            headerView.configure(
                userName: "호두마루 님",
                creationDate: "2022.10.10",
                settingTitle: data.title
            )
            
            headerView.changeMode(isShowProfile: indexPath.section == 0)
                    
            return headerView
        }
        
        collectionView
            .rx
            .modelSelected(SettingData.self)
            .subscribe(onNext: { [weak self] data in
                switch data.type {
                case .syncSocial(type: let type): // 소셜 연동하기
                    self?.viewModel.input.actionSocialSync.accept(type)
                    
                case .userLogOut: // 유저 로그아웃
                    self?.viewModel.input.actionUserLogout.accept(())
                    
                case .deleteAccount: // 유저 계정 탈퇴
                    let alertController = UIAlertController(
                        title: "",
                        message: "'Avocado'를 탈퇴하시겠습니까?",
                        preferredStyle: .alert
                    )
                    
                    alertController.addAction(
                        UIAlertAction(
                            title: "확인",
                            style: .default,
                            handler: { _ in
                                self?.viewModel.input.actionUserDeleteAccount.accept(())
                            }
                        )
                    )
                    
                    alertController.addAction(
                        UIAlertAction(
                            title: "취소",
                            style: .cancel
                        )
                    )
                    
                    self?.present(alertController, animated: true)
                    
                }
            })
            .disposed(by: disposeBag)
        
        // Output
        output.staticSettingData
            .bind(
                to:
                    collectionView.rx.items(
                        dataSource: dataSource
                    )
            )
            .disposed(by: disposeBag)
        
        // 소셜 연동
        output.successSocialSyncEvent
            .asSignal()
            .emit(onNext: { [weak self] url in
                guard let url = URL(string: url) else { return }
                Logger.d(url)
                let safariViewController = SFSafariViewController(url: url)
                self?.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 로그아웃
        output.successLogOutEvent
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.viewModel.steps.accept(ProfileStep.profileIsComplete)
            })
            .disposed(by: disposeBag)
        
        // 계정 삭제
        output.successDeleteAccountEvent
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.viewModel.steps.accept(ProfileStep.profileIsComplete)
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileVC: CollectionViewLayoutable {
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 10
            )
            
            var headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(160)
            )
            
            if section == 1 {
                headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(60)
                )
            }
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )

            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
import SafariServices
struct ProfileVCPreview: PreviewProvider {
    static var previews: some View {
        return UINavigationController(
            rootViewController: ProfileVC(
                viewModel: ProfileVM(
                    service: AuthService()
                )
            )
        ).toPreview()
    }
}
#endif
