import UIKit

extension UIButton {
    
    private enum Const {
        static let buttonImageLeadingAnchor: CGFloat = 9.6
        static let buttonImageTopAnchor: CGFloat = 4.9
        static let buttonImageHaight: CGFloat = 28.7
        static let leadingAnchor: CGFloat = 9
        static let topAnchor: CGFloat = 5
        static let heightAnchor: CGFloat = 30
        static let goToButtonLeadingAnchor: CGFloat = 65
        static let goToButtonHaightAnchor: CGFloat = 15
        static let borderWidth: CGFloat = 0.5
        static let shadowRadius: CGFloat = 10
        static let whiteHeart: UIImage = #imageLiteral(resourceName: "whHeart")
        static let redHeart: UIImage = #imageLiteral(resourceName: "redHeart")
        static let goTo: UIImage = #imageLiteral(resourceName: "goOver")
    }
    
    func setImage() {
        let buttonImage = UIImageView()
        buttonImage.image = Const.whiteHeart
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Const.buttonImageLeadingAnchor),
            buttonImage.topAnchor.constraint(equalTo: self.topAnchor, constant: Const.buttonImageTopAnchor),
            buttonImage.heightAnchor.constraint(equalToConstant: Const.buttonImageHaight),
            buttonImage.widthAnchor.constraint(equalToConstant: Const.buttonImageHaight)
        ])
    }
    
    func setRedImage() {
        let buttonImage = UIImageView()
        buttonImage.image = Const.redHeart
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Const.leadingAnchor),
            buttonImage.topAnchor.constraint(equalTo: self.topAnchor, constant: Const.topAnchor),
            buttonImage.heightAnchor.constraint(equalToConstant: Const.heightAnchor),
            buttonImage.widthAnchor.constraint(equalToConstant: Const.heightAnchor)
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
