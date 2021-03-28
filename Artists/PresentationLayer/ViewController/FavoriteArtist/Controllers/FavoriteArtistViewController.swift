import UIKit
import RealmSwift

final class FavoriteArtist: UICollectionViewController {
    
    // MARK:  Properties
    private var artists = try! Realm().objects(FavoriteArtists.self).sorted(byKeyPath: "name", ascending: true)
    private var networkServices = NetworkServices()
    private var favoriteCell = FavoriteCell()
    var favoriteArtist = FavoriteArtists()
    var currentArtist: CurrentArtist?
    private var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            return self.realm
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK:  Business logic
    // setting сonstraints for image and label
    private func setupConstraints(cell: FavoriteCell, image: UIImageView, label: UILabel) {
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            image.topAnchor.constraint(equalTo: cell.topAnchor),
            image.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            image.widthAnchor.constraint(equalToConstant: Const.widthItem),
            image.heightAnchor.constraint(equalToConstant: Const.widthItem - (Const.widthItem / Const.five))
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Const.spacingHorizontal),
            label.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            label.widthAnchor.constraint(equalToConstant: Const.widthItem)
        ])
    }
    
    // Removing an artist from the database Realm
    private func deleteFavoriteArtist(indexPath: IndexPath) {
        
        do {
            try? realm.write {
                let artist = self.artists[indexPath.row]
                realm.delete(artist)
                collectionView.reloadData()
            }
        }
    }
    
    func deleteArtistFromButton() {
        
        do {
            try? realm.write {
                for artist in artists {
                    if currentArtist?.name == artist.name {
                        realm.delete(artist)
                    }
                }
            }
        }
    }
    
    // save to the database Realm
    func saveArtist() {
        
        do {
            try? realm.write {
                let newArtist = FavoriteArtists()
                newArtist.name = currentArtist?.name
                newArtist.image = currentArtist?.imageURL
                realm.add(newArtist)
                self.favoriteArtist = newArtist
            }
        }
    }
    
    // Сhoose the time of the event: all, past, upcoming
    private func showAlertEvent(indexPath: IndexPath) {
        let attributedString = NSAttributedString(string: artists[indexPath.row].name!,
                                                  attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .largeTitle), NSAttributedString.Key.foregroundColor: UIColor.black])
        let alertEvent = UIAlertController(title: self.artists[indexPath.row].name!, message: "Выберите время события", preferredStyle: .actionSheet)
        alertEvent.setValue(attributedString, forKey: "attributedTitle")
        
        let allEvent = UIAlertAction(title: "Все", style: .default) { _ in
            self.networkServices.fetchEvent(artist: self.artists[indexPath.row].name!, date: "all") { currentEvent in
                DispatchQueue.main.async {
                    self.presentEventVC(with: currentEvent)
                }
            }
        }
        let pastEvent = UIAlertAction(title: "Прошедшие", style: .default) { (past) in
            self.networkServices.fetchEvent(artist: self.artists[indexPath.row].name!, date: "past") { currentEvent in
                DispatchQueue.main.async {
                    self.presentEventVC(with: currentEvent)
                }
            }
        }
        let upcomingEvent = UIAlertAction(title: "Предстоящие", style: .default) { (upcoming) in
            self.networkServices.fetchEvent(artist: self.artists[indexPath.row].name!, date: "upcoming") { currentEvent in
                DispatchQueue.main.async {
                    self.presentEventVC(with: currentEvent)
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
    
    private func presentEventVC(with currentEvent: [Event]) {
        let eventVC = EventsViewController(currentEvent: currentEvent)
        let navVC = UINavigationController(rootViewController: eventVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    // Choosing an option for a favorite
    @IBAction private func showAlert(_ sender: UITapGestureRecognizer) {
        if let sender = sender as? CustomTapGesture {
            guard let indexPath = sender.indexPath else {return}
            let attributedString = NSAttributedString(string: artists[indexPath.row].name ?? "nil",
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
}


// MARK: - Extensions
extension FavoriteArtist {
    
    // MARK:  UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        artists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath)
        
        if let favoriteArtistCell = cell as? FavoriteCell {
            setupConstraints(cell: favoriteArtistCell, image: favoriteArtistCell.imageFavoriteArtist, label: favoriteArtistCell.labelFavoriteArtist)
            
            favoriteCell.configureCell(cell: favoriteArtistCell, indexPath: indexPath)
            
            let tapGesture = CustomTapGesture(target: self, action: #selector(showAlert(_:)))
            tapGesture.indexPath = indexPath
            cell.addGestureRecognizer(tapGesture)
        }
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteArtist: UICollectionViewDelegateFlowLayout {
    
    private enum Const {
        static let spacingVertical: CGFloat = 30.0
        static let spacingHorizontal: CGFloat = 10
        static var widthItem: CGFloat = .zero
        static let item: CGFloat = 2.0
        static let spasing: CGFloat = 40
        static let spasingBetweenItems: CGFloat = 20
        static let one: CGFloat = 1
        static let five: CGFloat = 5
    }
    
    // Setting cell sizes
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let item = Const.item
        let spasing = Const.spasingBetweenItems * (item + Const.one)
        let freeWidth = collectionView.frame.width - spasing
        Const.widthItem = freeWidth / item
        return CGSize(width: Const.widthItem, height: Const.widthItem)
    }
    
    // Set the distance between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: Const.spacingVertical,
                     left: Const.spasing / (Const.item + Const.one),
                     bottom: Const.spacingVertical,
                     right: Const.spasing / (Const.item + Const.one))
    }
}

