import UIKit

@IBDesignable class UIPlaceholderTextView: UITextView {
    
    var placeholderLabel: UILabel?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshPlaceholder()
        refreshBorder()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)
    }

    @IBInspectable var placeholder: String? {
        didSet {
            refreshPlaceholder()
        }
    }

    @IBInspectable var placeholderColor: UIColor? = .darkGray {
        didSet {
            refreshPlaceholder()
        }
    }
    
    @IBInspectable var placeholderFontSize: CGFloat = 14 {
        didSet {
            refreshPlaceholder()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            refreshBorder()
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            refreshBorder()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            refreshBorder()
        }
    }


    func refreshPlaceholder() {
        if placeholderLabel == nil {
            placeholderLabel = UILabel()
            let contentView = self.subviews.first ?? self
            
            contentView.addSubview(placeholderLabel!)
            placeholderLabel?.translatesAutoresizingMaskIntoConstraints = false
            
            placeholderLabel?.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: textContainerInset.left + 4).isActive = true
            placeholderLabel?.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: textContainerInset.right + 4).isActive = true
            placeholderLabel?.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textContainerInset.top).isActive = true
            placeholderLabel?.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: textContainerInset.bottom)
        }
        placeholderLabel?.text = placeholder
        placeholderLabel?.textColor = placeholderColor
        placeholderLabel?.font = UIFont.systemFont(ofSize: placeholderFontSize)
    }
    
    func refreshBorder() {
        if borderWidth > 0 && borderColor != nil {
            layer.cornerRadius = cornerRadius
            layer.borderWidth = 1
            layer.borderColor = borderColor?.cgColor
        } else {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @objc func textChanged() {
        if self.placeholder?.isEmpty ?? true {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            if self.text.isEmpty {
                self.placeholderLabel?.alpha = 1.0
            } else {
                self.placeholderLabel?.alpha = 0.0
            }
        }
    }
    
    override var text: String! {
        didSet {
            textChanged()
        }
    }

    var isError: Bool = false
    func setError(_ isError: Bool) {
        if isError == self.isError {
            return
        }
        
        if isError {
            placeholderLabel?.textColor = .red
        } else {
            placeholderLabel?.textColor = placeholderColor
        }
        self.isError = isError
    }

}
