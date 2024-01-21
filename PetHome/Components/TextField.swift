import UIKit

final class TextField: UITextField {
    private let textPadding = UIEdgeInsets(
        top: 0,
        left: 16,
        bottom: 0,
        right: 41
    )
    
    convenience init(placeholder: String, security: Bool = false) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        clearButtonMode = .whileEditing
        layer.cornerRadius = 16
        textColor = .darkGray
        isSecureTextEntry = security
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

