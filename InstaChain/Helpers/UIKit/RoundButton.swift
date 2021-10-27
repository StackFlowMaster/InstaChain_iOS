import UIKit

@IBDesignable class RoundButton: UIButton {
    
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
    
    private func sharedInit() {
        refreshCorners(value: cornerRadius)
        refreshBackground(color: backgroundImageColor);
    }
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    @IBInspectable var backgroundImageColor: UIColor = .clear {
        didSet {
            refreshBackground(color: backgroundImageColor)
        }
    }
    
    private func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    private func createColorImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    private func refreshBackground(color: UIColor) {
        let image = createColorImage(color: color)
        setBackgroundImage(image, for: .normal)
        clipsToBounds = true
    }
}
