import UIKit
import SnapKit

final public class AIATextView: UIView {
    public enum State {
        case focused
        case unFocused
        case normal
        case error(_ text: String)
        case disabled
    }
    
    private let errorLabel = {
        let v = UILabel()
        v.textColor = .appColor(\.primary1)
        v.font = .appFont(\.body2R)
        v.numberOfLines = 0
        return v
    }()
    private let _textView = {
        let v = KMPlaceholderTextView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        v.layer.cornerRadius = 14
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.appColor(\.black40).cgColor
        v.clipsToBounds = true
        v.textContainerInset = .init(top: 30, left: 12, bottom: 12, right: 12)
        v.placeholderColor = .appColor(\.black50)
        v.placeholderFont = .appFont(\.body2M)
        v.font = .appFont(\.body1M)
        return v
    }()
    
    public var placeholder: String = "" {
        didSet {
            _textView.placeholder = placeholder
        }
    }
    public var maxLength: Int = 500
    
    public var textView: UITextView { _textView }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let stackViewContainer = {
            let v = UIStackView()
            v.axis = .vertical
            v.addArrangedSubview(_textView)
            v.addArrangedSubview(errorLabel)
            v.spacing = 10
            return v
        }()
        addSubview(stackViewContainer)
        stackViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        _textView.delegate = self
    }
    
    public func setState(_ state: State) {
        switch state {
        case .focused:
            _textView.layer.borderColor = UIColor.appColor(\.black40).cgColor
            errorLabel.isHidden = true
            _textView.becomeFirstResponder()
        case .unFocused:
            _textView.resignFirstResponder()
        case .normal:
            _textView.layer.borderColor = UIColor.appColor(\.black40).cgColor
            errorLabel.isHidden = true
        case let .error(errorText):
            _textView.layer.borderColor = UIColor(hexString: "E93E21").cgColor
            errorLabel.text = errorText
            errorLabel.isHidden = false
        case .disabled:
            _textView.layer.borderColor = UIColor.appColor(\.inactiveGray1).cgColor
        }
        
        switch state {
        case .disabled:
            _textView.isEditable = false
            _textView.placeholderLabel.textColor = .appColor(\.inactiveGray1)
            _textView.textColor = .appColor(\.inactiveGray1)
        default:
            _textView.isEditable = true
            _textView.placeholderLabel.textColor = .appColor(\.black50)
            _textView.textColor = .appColor(\.darkGray)
        }
    }
    
    public func setText(_ text: String) {
        _textView.text = String(text.prefix(maxLength))
    }
}

extension AIATextView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= maxLength
    }
}


/// https://github.com/MoZhouqi/KMPlaceholderTextView/tree/master
@IBDesignable
open class KMPlaceholderTextView: UITextView {
    
    private struct Constants {
        static let defaultiOSPlaceholderColor: UIColor = {
            if #available(iOS 13.0, *) {
                return .systemGray3
            }

            return UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
        }()
    }
  
    public let placeholderLabel: UILabel = UILabel()
    
    public var topInsetWhenFocus: CGFloat = 8  {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    public var topInsetWhenNotFocus: CGFloat = 20 {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    private var topFocusConstraint: Constraint?
    
    @IBInspectable open var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable open var placeholderColor: UIColor = KMPlaceholderTextView.Constants.defaultiOSPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    override open var font: UIFont! {
        didSet {
            if placeholderFont == nil {
                placeholderLabel.font = font
            }
        }
    }
    
    open var placeholderFont: UIFont? {
        didSet {
            let font = (placeholderFont != nil) ? placeholderFont : self.font
            placeholderLabel.font = font
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override open var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        #if swift(>=4.2)
        let notificationName = UITextView.textDidChangeNotification
        #else
        let notificationName = NSNotification.Name.UITextView.textDidChangeNotification
        #endif
      
        NotificationCenter.default.addObserver(self,
            selector: #selector(textDidChange),
            name: notificationName,
            object: nil)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(textDidBeginEdit),
            name: UITextView.textDidBeginEditingNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(textDidEndEdit),
            name: UITextView.textDidEndEditingNotification,
            object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        placeholderLabel.snp.remakeConstraints { make in
            make.width.equalToSuperview().inset(-(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0))
            make.leading.equalToSuperview().inset(textContainerInset.left + textContainer.lineFragmentPadding)
            make.top.equalToSuperview().inset(topInsetWhenNotFocus).priority(999)
            make.bottom.lessThanOrEqualToSuperview().inset(textContainerInset.bottom)
            topFocusConstraint = make.top.equalToSuperview().inset(topInsetWhenFocus).constraint
        }
    }
    
    @objc private func textDidBeginEdit() {
        UIView.animate(withDuration: 0.25) {
            self.topFocusConstraint?.activate()
            self.layoutIfNeeded()
        }
    }
    
    @objc private func textDidEndEdit() {
        guard text.isEmpty else { return }
        UIView.animate(withDuration: 0.25) {
            self.topFocusConstraint?.deactivate()
            self.layoutIfNeeded()
        }
    }
    
    @objc private func textDidChange() {
        if text.isEmpty && isFocused {
            topFocusConstraint?.deactivate()
        } else {
            topFocusConstraint?.activate()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    deinit {
      #if swift(>=4.2)
      let notificationName = UITextView.textDidChangeNotification
      #else
      let notificationName = NSNotification.Name.UITextView.textDidChangeNotification
      #endif
      
        NotificationCenter.default.removeObserver(self,
            name: notificationName,
            object: nil)
    }
    
}
