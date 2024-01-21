import UIKit

final class CustomStack: UIStackView {
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    convenience init(title: String, amount: Int) {
        self.init()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.alignment = .center
        self.spacing = 2
        
        textLabel.text = title
        amountLabel.text = String(amount)
        
        addArrangedSubview(textLabel)
        addArrangedSubview(amountLabel)
    }

}
