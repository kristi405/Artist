//
//  SearchArtistsViewController.swift
//  Artists
//
//  Created by kris on 06/11/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class SearchArtistsViewController: UICollectionViewController {
    
    var artists = [Artist]()
    var event = [Event]()
    var networkServices = NetworkServices()
    var currentArtistFavorite: CurrentArtist!
    var onComplition: ((CurrentArtist) -> Void)?
    var favoriteArtists: FavoriteArtists!
    var artistCell = ArtistCell()
    
    @IBAction func buttonPressed(sender: UIButton) {
        saveArtist()
        sender.setRedImage()
        print("добавлено в фавориты")
        print(favoriteArtists.name!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.collectionView.endEditing(true)
    }
    
// Сохраняем объект в базу Realm
    func saveArtist() {
        
        let realm = try! Realm()
        
        try! realm.write {
            let newArtist = FavoriteArtists()
            
            newArtist.name = self.currentArtistFavorite.name
            newArtist.image = self.currentArtistFavorite.imageURL
            
            realm.add(newArtist)
            self.favoriteArtists = newArtist
        }
    }
    
// Устанавливаем SearchController
    func setupSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Нужно ввести имя"
        
        searchController.searchBar.delegate = self
    }

// MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
        
        cell.button.isHidden = true
        cell.button.layer.borderWidth = 0.5
        cell.button.layer.shadowColor = UIColor.gray.cgColor
        cell.button.layer.shadowRadius = 10
        cell.button.layer.borderColor = UIColor.gray.cgColor
        cell.button.setImage()
        
        onComplition = { [weak self] currentArtist in
            guard let self = self else {return}
            self.currentArtistFavorite = currentArtist
            self.networkServices.fetchArtist(artist: currentArtist.name!, complition: { currentArtist in
                self.configureCell(cell: cell, artist: currentArtist)
                
                DispatchQueue.main.async {
                    cell.button.isHidden = false
                }
                print(currentArtist.name)
            })
        }
        
        return cell
    }
    
    private func configureCell(cell: ArtistCell, artist: CurrentArtist) {

        DispatchQueue.main.async {
         cell.artistName.text = artist.name
        }
         DispatchQueue.global().async {
            guard let dataUrl = URL(string: artist.imageURL!) else {return}
            guard let imageData = try? Data(contentsOf: dataUrl) else {return}
            
            DispatchQueue.main.async {
                cell.artistPhoto.image = UIImage(data: imageData)
            }
        }
    }
}


// MARK: - Extension UISearchBarDelegate
extension SearchArtistsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count < 3 {
            navigationController?.navigationItem.searchController?.searchBar.placeholder = "Нужно ввести имя"
        } else {
            self.networkServices.fetchArtist(artist: searchText, complition: { currentArtist in
                 self.onComplition?(currentArtist)
            })
        }
    }
}

// MARK: - Extension UICollectionViewDelegateFlowLayout
extension SearchArtistsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
}

extension SearchArtistsViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
