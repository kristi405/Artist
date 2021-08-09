import UIKit
import Rswift

extension UIButton {
    // MARK: Constants
    
    private enum Const {
        static let goToButtonLeadingAnchor: CGFloat = 65
        static let goToButtonHaightAnchor: CGFloat = 15
        static let borderWidth: CGFloat = 0.3
        static let shadowRadius: CGFloat = 10
        static let cornerRadius: CGFloat = 10
        static let goToText: String = "Перейти"
        static let shadowRadiusButton: CGFloat = 3
        static let shadowOpasity: Float = 5
        static let cornerRadiusButton: CGFloat = 15
    }
    
    // MARK: Set Buttons
    
    // Set image on button on the search screan
    func setImage(image: UIImage?, leadingAnchor: CGFloat, heightAnchor: CGFloat) {
        let buttonImage = UIImageView()
        buttonImage.image = image
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        guard let titleLabel = self.titleLabel else {return}
        NSLayoutConstraint.activate([
            buttonImage.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: leadingAnchor),
            buttonImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            buttonImage.heightAnchor.constraint(equalToConstant: heightAnchor),
            buttonImage.widthAnchor.constraint(equalToConstant: heightAnchor)
        ])
    }
    
    // Set image on button on event screan
    func setGoOverImage() {
        let buttonImage = UIImageView()
        buttonImage.image = R.image.goOver()
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Const.goToButtonLeadingAnchor),
            buttonImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            buttonImage.heightAnchor.constraint(equalToConstant: Const.goToButtonHaightAnchor),
            buttonImage.widthAnchor.constraint(equalToConstant: Const.goToButtonHaightAnchor)
        ])
    }
    
    // MARK: Custom button
    
    func customButton(button: UIButton) {
        button.setTitle(Const.goToText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Const.goToButtonHaightAnchor)
        button.titleLabel?.textAlignment = .natural
    }
    
    func searchVCBattons(button: UIButton) {
        button.isHidden = true
        button.backgroundColor = R.color.backgroundColor()
        button.layer.borderWidth = Const.borderWidth
        button.layer.shadowColor = UIColor.blue.cgColor
        button.layer.shadowRadius = Const.shadowRadius
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = Const.cornerRadius
    }
    
    func setMapButtonsStyle(button: UIButton, image: UIImage) {
        button.backgroundColor = .white
        button.layer.shadowRadius = Const.shadowRadiusButton
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = Const.shadowOpasity
        button.layer.cornerRadius = Const.cornerRadiusButton
        button.setImage(image, for: .normal)
        button.isHidden = false
    }
}
