import UIKit

extension UIButton {
    
    func setImage() {
        let buttonImage = UIImageView()
        buttonImage.image = #imageLiteral(resourceName: "WHeart")
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11.5),
            buttonImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 7.5),
            buttonImage.heightAnchor.constraint(equalToConstant: 25),
            buttonImage.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func setRedImage() {
        let buttonImage = UIImageView()
        buttonImage.image = #imageLiteral(resourceName: "redHeart")
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 9),
            buttonImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            buttonImage.heightAnchor.constraint(equalToConstant: 30),
            buttonImage.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setGoOverImage() {
        let buttonImage = UIImageView()
        buttonImage.image = #imageLiteral(resourceName: "goOver")
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 65),
            buttonImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            buttonImage.heightAnchor.constraint(equalToConstant: 15),
            buttonImage.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    func customButton(button: UIButton) {
        button.setTitle("Перейти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .natural
    }
}
