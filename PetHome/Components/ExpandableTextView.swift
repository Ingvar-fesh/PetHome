import UIKit

class ExpandableTextView: UITextView {
    
    private let maxCharacterCount = 250
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    private func commonInit() {
        self.isScrollEnabled = false
        self.delegate = self
        self.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = .black
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor(named: "newBlue")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
}

extension ExpandableTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateHeight()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Проверяем, не превысит ли общее количество символов максимальное значение
        guard let currentText = textView.text else { return true }
        let newLength = currentText.count + text.count - range.length
        
        if newLength <= maxCharacterCount {
            return true
        } else {
            // Показываем пользователю сообщение о превышении максимального количества символов
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let viewController = scene.windows.first?.rootViewController {
                    let alert = UIAlertController(title: "Ошибка", message: "Превышено максимальное количество символов (\(maxCharacterCount)).", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
                    alert.addAction(okAction)
                    viewController.present(alert, animated: true, completion: nil)
                }
            }
            return false
        }
    }
    
    private func updateHeight() {
        let size = CGSize(width: self.bounds.width, height: .infinity)
        let estimatedSize = self.sizeThatFits(size)
        self.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = min(estimatedSize.height, 200) // Максимальная высота поля
            }
        }
        self.isScrollEnabled = estimatedSize.height >= 200 // Включение прокрутки, если текст превышает максимальную высоту
    }
    
    @objc 
    private func handleTextChange(_ notification: Notification) {
        if !self.isFirstResponder {
            self.becomeFirstResponder()
        }
    }
    
    @objc 
    private func dismissKeyboard() {
        self.resignFirstResponder()
    }
}
