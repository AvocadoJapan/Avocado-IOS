//
//  UploadVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/30.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then
//import PhotosUI

final class UploadVC: BaseVC {
    
    private let viewModel: UploadVM
    
//    private lazy var scrollView = UIScrollView().then {
//        $0.showsVerticalScrollIndicator = false
//        $0.contentInsetAdjustmentBehavior = .never
////        $0.delegate = self
//    }
//    private lazy var stackView = UIStackView().then {
//        $0.axis = .vertical
//        $0.spacing = 10
//    }
//    
//    private lazy var imageCVLayout = UICollectionViewFlowLayout().then {
//        $0.scrollDirection = .horizontal
//        $0.minimumLineSpacing = 10
//        $0.minimumInteritemSpacing = 0
//        $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//    }
//    private lazy var imageCV = UICollectionView(frame: .zero, collectionViewLayout: self.imageCVLayout).then {
//        $0.showsHorizontalScrollIndicator = false
//        $0.isPagingEnabled = true
////        $0.backgroundColor = .systemCyan
//    }
//    
//    private lazy var inputStackView = UIStackView().then {
//        $0.axis = .vertical
//        $0.spacing = 20
//        
//        $0.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//        $0.isLayoutMarginsRelativeArrangement = true
//    }
//    
//    private lazy var titleInput = InputView(label: "상품명 (필수)")
//    private lazy var priceInput = InputView(label: "가격 (필수)")
//    private lazy var descriptionInput = InputView(label: "상품설명 (임의)")
//    private lazy var locationInput = InputView(label: "지역 (임의)")
//    private lazy var shippingTimeInput = InputView(label: "발송까지 걸리는 시간 (임의)")
//    
//    private lazy var uploadButton = BottomButton(text: "업로드 하기", buttonType: .primary)
//    
//    private lazy var demoLabel = UILabel().then {
//        $0.numberOfLines = 0
//        $0.text =
//            """
//            모든 국민은 근로의 권리를 가진다. 국가는 사회적·경제적 방법으로 근로자의 고용의 증진과 적정임금의 보장에 노력하여야 하며, 법률이 정하는 바에 의하여 최저임금제를 시행하여야 한다.
//
//            국회는 법률에 저촉되지 아니하는 범위안에서 의사와 내부규율에 관한 규칙을 제정할 수 있다.
//
//            헌법개정은 국회재적의원 과반수 또는 대통령의 발의로 제안된다.
//
//            모든 국민은 인간다운 생활을 할 권리를 가진다. 의원을 제명하려면 국회재적의원 3분의 2 이상의 찬성이 있어야 한다.
//
//            국가원로자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다.
//
//            군인·군무원·경찰공무원 기타 법률이 정하는 자가 전투·훈련등 직무집행과 관련하여 받은 손해에 대하여는 법률이 정하는 보상외에 국가 또는 공공단체에 공무원의 직무상 불법행위로 인한 배상은 청구할 수 없다.
//
//            국회는 국가의 예산안을 심의·확정한다. 지방자치단체는 주민의 복리에 관한 사무를 처리하고 재산을 관리하며, 법령의 범위안에서 자치에 관한 규정을 제정할 수 있다.
//
//            이 헌법시행 당시에 이 헌법에 의하여 새로 설치될 기관의 권한에 속하는 직무를 행하고 있는 기관은 이 헌법에 의하여 새로운 기관이 설치될 때까지 존속하며 그 직무를 행한다.
//
//            모든 국민은 건강하고 쾌적한 환경에서 생활할 권리를 가지며, 국가와 국민은 환경보전을 위하여 노력하여야 한다.
//
//            대통령의 임기연장 또는 중임변경을 위한 헌법개정은 그 헌법개정 제안 당시의 대통령에 대하여는 효력이 없다.
//
//            각급 선거관리위원회의 조직·직무범위 기타 필요한 사항은 법률로 정한다.
//
//            체포·구속·압수 또는 수색을 할 때에는 적법한 절차에 따라 검사의 신청에 의하여 법관이 발부한 영장을 제시하여야 한다. 다만, 현행범인인 경우와 장기 3년 이상의 형에 해당하는 죄를 범하고 도피 또는 증거인멸의 염려가 있을 때에는 사후에 영장을 청구할 수 있다.
//
//            대법원장의 임기는 6년으로 하며, 중임할 수 없다. 국회나 그 위원회의 요구가 있을 때에는 국무총리·국무위원 또는 정부위원은 출석·답변하여야 하며, 국무총리 또는 국무위원이 출석요구를 받은 때에는 국무위원 또는 정부위원으로 하여금 출석·답변하게 할 수 있다.
//
//            환경권의 내용과 행사에 관하여는 법률로 정한다. 국회는 의장 1인과 부의장 2인을 선출한다.
//
//            국무총리는 국무위원의 해임을 대통령에게 건의할 수 있다. 군사법원의 조직·권한 및 재판관의 자격은 법률로 정한다.
//
//            국회의원은 현행범인인 경우를 제외하고는 회기중 국회의 동의없이 체포 또는 구금되지 아니한다.
//
//            누구든지 체포 또는 구속의 이유와 변호인의 조력을 받을 권리가 있음을 고지받지 아니하고는 체포 또는 구속을 당하지 아니한다. 체포 또는 구속을 당한 자의 가족등 법률이 정하는 자에게는 그 이유와 일시·장소가 지체없이 통지되어야 한다.
//
//            모든 국민은 법률이 정하는 바에 의하여 공무담임권을 가진다.
//
//            위원은 정당에 가입하거나 정치에 관여할 수 없다. 법률이 헌법에 위반되는 여부가 재판의 전제가 된 경우에는 법원은 헌법재판소에 제청하여 그 심판에 의하여 재판한다.
//
//            국정의 중요한 사항에 관한 대통령의 자문에 응하기 위하여 국가원로로 구성되는 국가원로자문회의를 둘 수 있다.
//            """
//    }
//    
//    
//    //    let photos: [UIImage] = [UIImage(named: "demo_product_ipad")!]
    
    init(viewModel: UploadVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func setProperty() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = "상품업로드"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkText]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkText]
            navBarAppearance.backgroundColor = .white
            navBarAppearance.shadowColor = .white
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct UploadVCPreview: PreviewProvider {
    static var previews: some View {
        return UploadVC(viewModel: UploadVM(service: UploadService())).toPreview()
    }
}
#endif
