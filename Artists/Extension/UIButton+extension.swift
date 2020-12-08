//
//  UIButton+extension.swift
//  Artists
//
//  Created by kris on 09/11/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setImage() {
        let buttonImage = UIImageView()
        buttonImage.image = #imageLiteral(resourceName: "heart-7")
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            buttonImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setRedImage() {
        let buttonImage = UIImageView()
        buttonImage.image = #imageLiteral(resourceName: "redHeart")
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17),
            buttonImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            buttonImage.heightAnchor.constraint(equalToConstant: 37),
            buttonImage.widthAnchor.constraint(equalToConstant: 37)
        ])
    }
    
    func setGoOverImage() {
        let buttonImage = UIImageView()
        buttonImage.image = #imageLiteral(resourceName: "goOver")
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonImage)
        NSLayoutConstraint.activate([
            buttonImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 100),
            buttonImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            buttonImage.heightAnchor.constraint(equalToConstant: 20),
            buttonImage.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func customButton(button: UIButton) {
        button.setTitle("Перейти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .left
        button.layer.borderWidth = 0.2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = 5
    }
}
