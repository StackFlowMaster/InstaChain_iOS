import UIKit

class TintButton: UIButton {
    
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
        refreshTintColor()
        super.draw(rect)
    }

    func sharedInit() {
        refreshTintColor()
    }

    func refreshTintColor() {
        if self.isSelected && selectedColor != nil {
            self.tintColor = selectedColor
        }
        else if self.isEnabled && enabledColor != nil {
            self.tintColor = enabledColor
        }
        else if !self.isEnabled && disabledColor != nil {
            self.tintColor = disabledColor
        }
    }
    
    @IBInspectable var enabledColor: UIColor? {
        didSet {
            refreshTintColor()
        }
    }
    
    @IBInspectable var selectedColor: UIColor? {
        didSet {
            refreshTintColor()
        }
    }

    @IBInspectable var disabledColor: UIColor? {
        didSet {
            refreshTintColor()
        }
    }

}
