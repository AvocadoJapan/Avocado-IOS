import UIKit
import SnapKit

final class RegionTVCell: UITableViewCell {
    
    static let identifier: String = "RegionTVCell"
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        $0.textColor = .darkText
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .systemGray6
        
        self.selectedBackgroundView = UIView().then {
            $0.backgroundColor = .systemGray5
        }
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
    }
    
    func configure(with region: Region) {
        nameLabel.text = region.fullName
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
        selectedBackgroundView?.backgroundColor = selected ? .systemGray5 : nil
    }
}
