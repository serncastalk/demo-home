import UIKit
import SnapKit

final class AvatarOptionView: UIControl {
    private let playButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let radioOuter = UIView()
    private let radioInner = UIView()

    var title: String? {
        didSet { titleLabel.text = title }
    }

    var onSelect: ((AvatarOptionView) -> Void)?

    override var isSelected: Bool {
        didSet { updateSelectionAppearance() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        let playImage = UIImage(systemName: "play.fill")
        playButton.setImage(playImage, for: .normal)
        playButton.tintColor = .appColor(\.darkGray)
        playButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        playButton.layer.cornerRadius = 24
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.appColor(\.middleGray).cgColor
        playButton.backgroundColor = .clear
        addSubview(playButton)

        titleLabel.font = .appFont(\.h5)
        titleLabel.textColor = .appColor(\.darkGray)
        addSubview(titleLabel)

        radioOuter.layer.cornerRadius = 16
        radioOuter.layer.borderWidth = 2
        radioOuter.layer.borderColor = UIColor.appColor(\.middleGray).cgColor
        radioOuter.backgroundColor = .clear
        addSubview(radioOuter)

        radioInner.backgroundColor = .appColor(\.white)
        radioInner.layer.cornerRadius = 10
        radioInner.isHidden = true
        radioOuter.addSubview(radioInner)

        playButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(playButton.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }

        radioOuter.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }

        radioInner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }

        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(76)
        }

        addTarget(self, action: #selector(didTapSelf), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)

        isAccessibilityElement = true
        accessibilityTraits = .button
        updateSelectionAppearance()
    }

    @objc private func didTapSelf() {
        isSelected = true
        onSelect?(self)
    }

    @objc private func didTapPlay() {
        let original = playButton.transform
        UIView.animate(withDuration: 0.12, animations: {
            self.playButton.transform = original.scaledBy(x: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.12) {
                self.playButton.transform = original
            }
        }
    }

    private func updateSelectionAppearance() {
        radioInner.isHidden = !isSelected
        if isSelected {
            radioOuter.backgroundColor = UIColor.appColor(\.black)
            radioOuter.layer.borderColor = UIColor.appColor(\.black).cgColor
            radioInner.backgroundColor = UIColor.appColor(\.white)
            titleLabel.textColor = UIColor.appColor(\.black)
            accessibilityTraits.insert(.selected)
        } else {
            radioOuter.backgroundColor = .clear
            radioOuter.layer.borderColor = UIColor.appColor(\.middleGray).cgColor
            radioInner.backgroundColor = UIColor.appColor(\.white)
            titleLabel.textColor = UIColor.appColor(\.darkGray)
            accessibilityTraits.remove(.selected)
        }
    }
}
