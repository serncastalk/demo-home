import UIKit
import SnapKit

final class AvatarOptionCell: UITableViewCell {
    static let reuseIdentifier = "AvatarOptionCell"

    private let optionView = AvatarOptionView()
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.92, alpha: 1)
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        selectionStyle = .none
        contentView.addSubview(optionView)
        contentView.addSubview(separatorView)

        optionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(separatorView.snp.top)
            make.height.greaterThanOrEqualTo(76)
        }

        separatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }

    func configure(title: String, selected: Bool) {
        optionView.title = title
        optionView.isSelected = selected
    }

    func setOnSelect(_ callback: @escaping (AvatarOptionView) -> Void) {
        optionView.onSelect = callback
    }
}
