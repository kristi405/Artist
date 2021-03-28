import UIKit

extension UIButton {
    
    private enum Const {
        static let goToButtonLeadingAnchor: CGFloat = 65
        static let goToButtonHaightAnchor: CGFloat = 15
        static let borderWidth: CGFloat = 0.5
        static let shadowRadius: CGFloat = 10
        static let goTo: UIImage = #imageLiteral(resourceName: "goOver")
    }
    
    func setImage(image: UIImage, leadingAnchor: CGFloat, topAnchor: CGFloat, heightAnchor: CGFloat) {
        let buttonImage = UIImageView()
        buttonImage.image = image
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
            buttonImage.topAnchor.constraint(equalTo: self.topAnchor, constant: topAnchor),
            buttonImage.heightAnchor.constraint(equalToConstant: heightAnchor),
            buttonImage.widthAnchor.constraint(equalToConstant: heightAnchor)
        ])
    }
    
    func setGoOverImage() {
        let buttonImage = UIImageView()
        buttonImage.image = Const.goTo
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Const.goToButtonLeadingAnchor),
            buttonImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            buttonImage.heightAnchor.constraint(equalToConstant: Const.goToButtonHaightAnchor),
            buttonImage.widthAnchor.constraint(equalToConstant: Const.goToButtonHaightAnchor)
        ])
    }
    
    func customButton(button: UIButton) {
        button.setTitle("Перейти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Const.goToButtonHaightAnchor)
        button.titleLabel?.textAlignment = .natural
    }
    
    func searchVCBattons(button: UIButton) {
        button.isHidden = true
        button.layer.borderWidth = Const.borderWidth
        button.layer.shadowColor = UIColor.blue.cgColor
        button.layer.shadowRadius = Const.shadowRadius
        button.layer.borderColor = UIColor.blue.cgColor
    }
}
