import UIKit

class TwoLineButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    override func draw(_ rect: CGRect) {
        refreshTitle()
        super.draw(rect)
    }

    func sharedInit() {
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textAlignment = .center
        refreshTitle()
    }

    func refreshTitle() {
        let originalFont = self.titleLabel?.font ?? UIFont.systemFont(ofSize: mainFontSize)
        let mainFont = originalFont.withSize(mainFontSize)
        let subFont = originalFont.withSize(subFontSize)
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        let mainAttrString = NSMutableAttributedString(string: mainTitle ?? "", attributes: [.font: mainFont, .paragraphStyle: titleParagraphStyle])
        let subAttrString = NSAttributedString(string: subTitle ?? "", attributes: [.font: subFont, .paragraphStyle: titleParagraphStyle])
        mainAttrString.append(NSAttributedString(string: "\n"))
        mainAttrString.append(subAttrString)
        self.setAttributedTitle(mainAttrString, for: .normal)
    }
    
    @IBInspectable var mainTitle: String? {
        didSet {
            refreshTitle()
        }
    }
    
    @IBInspectable var subTitle: String? {
        didSet {
            refreshTitle()
        }
    }
    
    @IBInspectable var mainFontSize: CGFloat = 17 {
        didSet {
            refreshTitle()
        }
    }
    
    @IBInspectable var subFontSize: CGFloat = 14 {
        didSet {
            refreshTitle()
        }
    }

}
