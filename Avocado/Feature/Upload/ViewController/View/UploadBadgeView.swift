//
//  UploadBadgeView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/01.
//

final class UploadBadgeView: UIView {
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "bolt_solid")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 5
    }
    
    private lazy var titleLabel = UILabel().then{
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.text = "알 수 없는 오류"
        $0.textColor = .darkText
    }
    
    private lazy var descriptionLabel = UILabel().then{
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "오류가 발생했어요"
        $0.textColor = .gray
    }
    
    private lazy var descriptionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private lazy var toggle = UISwitch().then {
        $0.onTintColor = .black
        $0.preferredStyle = .checkbox
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(descriptionStackView)
        addSubview(toggle)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        
        descriptionStackView.addArrangedSubview(imageView)
        descriptionStackView.addArrangedSubview(labelStackView)
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(self.snp.height).dividedBy(1.7)
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.centerY.left.equalToSuperview()
        }
        
        toggle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.greaterThanOrEqualTo(descriptionStackView.snp.right)
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: ProductBadge) {
        self.init(frame: .zero)
        
        titleLabel.text = type.title
        descriptionLabel.text = type.sellerDescription
        imageView.image = UIImage(named: "\(type.image)")
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct UploadBadgeViewPreview: PreviewProvider {
    static var previews: some View {
        return UploadBadgeView().toPreview().previewLayout(.fixed(width: 300, height: 50))
    }
}
#endif


