//
//  FavoriteArtist.swift
//  Artists
//
//  Created by kris on 09/11/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteArtist: UICollectionViewController {
    
    private var artists = try! Realm().objects(FavoriteArtists.self).sorted(byKeyPath: "name", ascending: true)
    var favoriteArtists: FavoriteArtists!
    var networkServices = NetworkServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    
// MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        
        configureCell(cell: cell, indexPath: indexPath)

        let tapGesture = CustomTapGesture(target: self, action: #selector(showAlert(_:)))
        tapGesture.indexPath = indexPath
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    private func configureCell(cell: FavoriteCell, indexPath: IndexPath) {
        
        let artist = artists[indexPath.row]
        
        cell.labelFavoriteArtist.text = artist.name
        
        guard let dataUrl = URL(string: artist.image!) else {return}
        guard let imageData = try? Data(contentsOf: dataUrl) else {return}
        cell.imageFavoriteArtist.image = UIImage(data: imageData)
    }
    
    @objc func showAlert(_ sender: UITapGestureRecognizer) {
        if let sender = sender as? CustomTapGesture {
            guard let indexPath = sender.indexPath else {return}
            let attributedString = NSAttributedString(string: artists[indexPath.row].name!,
                                                      attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.black])

            let ac = UIAlertController(title: "", message: "Выберите действие", preferredStyle: .alert)
            ac.setValue(attributedString, forKey: "attributedTitle")
            
            let showDetale = UIAlertAction(title: "Показать события", style: .default) { show in
                self.showAlertEvent(indexPath: indexPath)
            }
            
            let deleteAction = UIAlertAction(title: "Удалить", style: .default) { delete in
                self.deleteFavoriteArtist(indexPath: indexPath)
            }
            
            let cencelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            ac.addAction(showDetale)
            ac.addAction(deleteAction)
            ac.addAction(cencelButton)
            
            self.present(ac, animated: true, completion: nil)
        }
    }
   
    private func deleteFavoriteArtist(indexPath: IndexPath) {
        let realm = try! Realm()

        try! realm.write {
            let artist = self.artists[indexPath.row]
            realm.delete(artist)
            collectionView.reloadData()
        }
    }

    private func showAlertEvent(indexPath: IndexPath) {
        
        let attributedString = NSAttributedString(string: artists[indexPath.row].name!,
                                                  attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .largeTitle), NSAttributedString.Key.foregroundColor: UIColor.black])
        let alertEvent = UIAlertController(title: self.artists[indexPath.row].name!, message: "Выберите время события", preferredStyle: .actionSheet)
        alertEvent.setValue(attributedString, forKey: "attributedTitle")
        
        let allEvent = UIAlertAction(title: "Все", style: .default) { _ in
            self.networkServices.fetchEvent(artist: self.artists[indexPath.row].name!, date: "all") { currentEvent in
                DispatchQueue.main.async {
                    let eventVC = EventsViewController(currentEvent: currentEvent)
                    self.present(eventVC, animated: true, completion: nil)
                }
            }
        }
        let pastEvent = UIAlertAction(title: "Прошедшие", style: .default) { (past) in
            self.networkServices.fetchEvent(artist: self.artists[indexPath.row].name!, date: "past") { currentEvent in
                DispatchQueue.main.async {
                    let eventVC = EventsViewController(currentEvent: currentEvent)
                    self.present(eventVC, animated: true, completion: nil)
                }
            }
        }
        let upcomingEvent = UIAlertAction(title: "Предстоящие", style: .default) { (upcoming) in
            self.networkServices.fetchEvent(artist: self.artists[indexPath.row].name!, date: "upcoming") { currentEvent in
                DispatchQueue.main.async {
                    let eventVC = EventsViewController(currentEvent: currentEvent)
                    self.present(eventVC, animated: true, completion: nil)
                }
            }
        }
        
        let cencelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertEvent.addAction(allEvent)
        alertEvent.addAction(pastEvent)
        alertEvent.addAction(upcomingEvent)
        alertEvent.addAction(cencelButton)
        alertEvent.view.addSubview(UIView())
        present(alertEvent, animated: false, completion: nil)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteArtist: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
          let item: CGFloat = 2
          let spasing = 20 * (item + 1)
          let freeWidth = collectionView.frame.width - spasing
          let widthItem = freeWidth / item
          return CGSize(width: widthItem, height: widthItem)
      }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 15, bottom: 25, right: 15)
    }
}

