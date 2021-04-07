import UIKit
import RealmSwift

final class FavoriteArtist: UICollectionViewController {
    // MARK:  Private Properties
    
    private var artists = try? Realm().objects(FavoriteArtists.self).sorted(byKeyPath: "name", ascending: true)
    private var networkServices = NetworkServices()
    private var favoriteCell = FavoriteCell()
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
    
    // MARK:  Public Properties
    
    var favoriteArtist = FavoriteArtists()
    var currentArtist: CurrentArtist?
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Const.color
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.backgroundColor = Const.color
    }
    
    // MARK: IBActions
    
    // Choosing an option for a favorite
      @IBAction private func showAlert(_ sender: UITapGestureRecognizer) {
          if let sender = sender as? CustomTapGesture {
              guard let indexPath = sender.indexPath else {return}
            guard let artists = artists else {return}
            let attributedString = NSAttributedString(string: artists[indexPath.row].name ?? Const.all,
                                                        attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.black])
              
            let ac = UIAlertController(title: "", message: Const.chooseAction, preferredStyle: .alert)
              ac.setValue(attributedString, forKey: "attributedTitle")
              
            let showDetale = UIAlertAction(title: Const.showEvent, style: .default) { show in
                  self.showAlertEvent(indexPath: indexPath)
              }
              
            let deleteAction = UIAlertAction(title: Const.delete, style: .default) { delete in
                  self.deleteFavoriteArtist(indexPath: indexPath)
              }
              
            let cencelButton = UIAlertAction(title: Const.cancel, style: .cancel, handler: nil)
              
              ac.addAction(showDetale)
              ac.addAction(deleteAction)
              ac.addAction(cencelButton)
              
              self.present(ac, animated: true, completion: nil)
          }
      }
    
    // MARK:  Private Methods
    
    // setting сonstraints for image and label
    private func setupConstraints(cell: FavoriteCell, image: UIImageView, label: UILabel) {
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        label.textColor = .black
        
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
                guard let artists = artists else {return}
                let artist = artists[indexPath.row]
                realm.delete(artist)
                collectionView.reloadData()
            }
        }
    }
    
    // Сhoose the time of the event: all, past, upcoming
    private func showAlertEvent(indexPath: IndexPath) {
        guard let artists = artists else {return}
        let attributedString = NSAttributedString(string: artists[indexPath.row].name ?? Const.all,
                                                  attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .largeTitle), NSAttributedString.Key.foregroundColor: UIColor.black])
        let alertEvent = UIAlertController(title: artists[indexPath.row].name!, message: Const.nameAlert, preferredStyle: .actionSheet)
        alertEvent.setValue(attributedString, forKey: "attributedTitle")
        
        let allEvent = UIAlertAction(title: Const.all, style: .default) { _ in
            self.networkServices.fetchEvent(artist: artists[indexPath.row].name ?? Const.all, date: Const.all) { currentEvent in
                DispatchQueue.main.async {
                    self.presentEventVC(with: currentEvent)
                }
            }
        }
        let pastEvent = UIAlertAction(title: Const.past, style: .default) { (past) in
            self.networkServices.fetchEvent(artist: artists[indexPath.row].name ?? Const.all, date: Const.past) { currentEvent in
                DispatchQueue.main.async {
                    self.presentEventVC(with: currentEvent)
                }
            }
        }
        let upcomingEvent = UIAlertAction(title: Const.upcoming, style: .default) { (upcoming) in
            self.networkServices.fetchEvent(artist: artists[indexPath.row].name ?? Const.all, date: Const.upcoming) { currentEvent in
                DispatchQueue.main.async {
                    self.presentEventVC(with: currentEvent)
                }
            }
        }
        
        let cencelButton = UIAlertAction(title: Const.cancel, style: .cancel, handler: nil)
        
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
    
    // MARK:  Public Methods
    
    // delete Artist from search screan
    func deleteArtistFromButton() {
        do {
            try? realm.write {
                guard let artists = artists else {return}
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
}


// MARK: - Extensions UICollectionView DataSource
extension FavoriteArtist {
    // MARK:  UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let artists = artists else {return 1}
        return artists.count
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
    
    // Constants
    private enum Const {
        static let spacingVertical: CGFloat = 30.0
        static let spacingHorizontal: CGFloat = 10
        static var widthItem: CGFloat = .zero
        static let item: CGFloat = 2.0
        static let spasing: CGFloat = 40
        static let spasingBetweenItems: CGFloat = 20
        static let one: CGFloat = 1
        static let five: CGFloat = 5
        static let color = UIColor(named: "Color")
        static let all: String = "all"
        static let past: String = "past"
        static let upcoming: String = "upcoming"
        static let cancel: String = "Отмена"
        static let nameAlert: String = "Выберите время события"
        static let showEvent: String = "Показать событие"
        static let delete: String = "Удалить"
        static let chooseAction: String = "Выберите действие"
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

