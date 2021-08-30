import UIKit
import RealmSwift
import Moya

final class FavoriteArtist: UICollectionViewController {
    // MARK:  Private Properties
    
    private var artists = try? Realm().objects(FavoriteArtists.self).sorted(byKeyPath: SearchVCString.name.rawValue, ascending: true)
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
    private var events: [Event]?
    private let artistService = ArtistService()
    
    // MARK:  Public Properties
    
    var favoriteArtist: FavoriteArtists?
    var currentArtist: CurrentArtist?
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = R.color.color()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .black
    }
    
    // MARK: Overrade methods
    
    // Move to another screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == FaviritsVCString.showEvent.rawValue {
            guard let eventVC = segue.destination as? EventVC else {return}
            guard let events = self.events else {return}
            eventVC.events = events
        }
    }
    
    // MARK: Private methods
    
    // Choosing an option for a favorite
    private func showAlert(artist: FavoriteArtists) {
        let attributedString = NSAttributedString(string: artist.name ?? FaviritsVCString.all.rawValue,
                                                  attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        let ac = UIAlertController(title: nil, message: FaviritsVCString.chooseTheAction.rawValue.stringValue, preferredStyle: .alert)
        ac.setValue(attributedString, forKey: FaviritsVCString.attributedTitle.rawValue)
        
        let showDetale = UIAlertAction(title: FaviritsVCString.showTheEvents.rawValue.stringValue, style: .default) { show in
            self.showAlertEvent(artist: artist)
        }
        
        let deleteAction = UIAlertAction(title: FaviritsVCString.delete.rawValue, style: .default) { delete in
            self.deleteFavoriteArtist(artist: artist)
        }
        
        let cencelButton = UIAlertAction(title: FaviritsVCString.cancel.rawValue, style: .cancel, handler: nil)
        
        ac.addAction(showDetale)
        ac.addAction(deleteAction)
        ac.addAction(cencelButton)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    // MARK:  Private Methods
    
    // Removing an artist from the database Realm
    private func deleteFavoriteArtist(artist: FavoriteArtists) {
        do { try? realm.write {
            realm.delete(artist)
            collectionView.reloadData()}
        }
    }
    
    // Sent events to MapViewController
    private func sentEvents(currentEvents: [Event]) {
        DispatchQueue.main.async {
            let mapViewController = self.tabBarController?.viewControllers?.last as? MapViewController
            guard let mapVC = mapViewController else {return}
            if mapVC.events.isEmpty == true {
                mapVC.events = currentEvents
            } else {
                mapVC.events = []
                guard let annotation = mapVC.annotations else {return}
                mapVC.mapView.removeAnnotations(annotation)
                mapVC.events = currentEvents
            }
            self.performSegue(withIdentifier: R.segue.favoriteArtist.showEvent, sender: self)
        }
    }
    
    // Get artist's events
    private func getEvent(artist: String, date: String) {
        let name = GetArtistName(name: artist)
        let date = GetDate(date: date)
        
        artistService.getEvents(artist: name, date: date) { events in
            self.events = events
            self.sentEvents(currentEvents: events)
        }
    }
    
    // Сhoose the time of the event: all, past, upcoming
    private func showAlertEvent(artist: FavoriteArtists) {
        let attributedString = NSAttributedString(string: artist.name ?? FaviritsVCString.all.rawValue,
                                                  attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .largeTitle), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        let alertEvent = UIAlertController(title: artist.name, message: FaviritsVCString.chooseTheTime.rawValue.stringValue, preferredStyle: .actionSheet)
        alertEvent.setValue(attributedString, forKey: FaviritsVCString.attributedTitle.rawValue)
        
        let allEvent = UIAlertAction(title: FaviritsVCString.all.rawValue, style: .default) { _ in
            self.getEvent(artist: artist.name ?? FaviritsVCString.all.rawValue, date: FaviritsVCString.all.rawValue)
        }
        let pastEvent = UIAlertAction(title: FaviritsVCString.past.rawValue, style: .default) { (past) in
            self.getEvent(artist: artist.name ?? FaviritsVCString.all.rawValue, date: FaviritsVCString.past.rawValue)
        }
        let upcomingEvent = UIAlertAction(title: FaviritsVCString.upcoming.rawValue, style: .default) { (upcoming) in
            self.getEvent(artist: artist.name ?? FaviritsVCString.all.rawValue, date: FaviritsVCString.upcoming.rawValue)
        }
        
        let cencelButton = UIAlertAction(title: FaviritsVCString.cancel.rawValue, style: .cancel, handler: nil)
        
        alertEvent.addAction(allEvent)
        alertEvent.addAction(pastEvent)
        alertEvent.addAction(upcomingEvent)
        alertEvent.addAction(cencelButton)
        
        alertEvent.view.addSubview(UIView())
        present(alertEvent, animated: false, completion: nil)
    }
    
    // MARK:  Public Methods
    
    // delete Artist from search screan
    func deleteArtistFromButton() {
        do { try? realm.write {
            guard let artists = artists else {return}
            for artist in artists {
                if currentArtist?.name == artist.name {
                    realm.delete(artist)
                }
            }
        }}
    }
    
    // save to the database Realm
    func saveArtist() {
        do { try? realm.write {
            let newArtist = FavoriteArtists()
            newArtist.name = currentArtist?.name
            newArtist.image = currentArtist?.imageURL
            realm.add(newArtist)
            self.favoriteArtist = newArtist
        }}
    }
}


// MARK: - Extensions UICollectionView DataSource
extension FavoriteArtist {
    // MARK:  UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let artists = artists else {return .zero}
        return artists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.favoriteCell, for: indexPath)
        var favoriteCell = FavoriteCell()
        
        if let favoriteArtistCell = cell {
            guard let artists = self.artists else {return favoriteArtistCell}
            let artist = artists[indexPath.row]
            favoriteCell = favoriteArtistCell
            
            favoriteArtistCell.configureCell(artist: artist)
        }
        return favoriteCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let artists = self.artists else {return}
        let artist = artists[indexPath.row]
        showAlert(artist: artist)
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteArtist: UICollectionViewDelegateFlowLayout {
    
    // Setting cell sizes
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let item = Constants.item
        let spasing = Constants.spasingBetweenItems * (item + Constants.one)
        let freeWidth = collectionView.frame.width - spasing
        Constants.widthItem = freeWidth / item
        return CGSize(width: Constants.widthItem, height: Constants.widthItem)
    }
    
    // Set the distance between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: Constants.cellSpacingVertical,
                     left: Constants.cellSpasing / (Constants.item + Constants.one),
                     bottom: Constants.cellSpacingVertical,
                     right: Constants.cellSpasing / (Constants.item + Constants.one))
    }
}

extension FavoriteArtist {
    
    // Constants
    private enum Constants {
        static let cellSpacingVertical: CGFloat = 30.0
        static var widthItem: CGFloat = .zero
        static let item: CGFloat = 2.0
        static let cellSpasing: CGFloat = 40
        static let spasingBetweenItems: CGFloat = 20
        static let one: CGFloat = 1
//        static let cancel: String = "Отмена"
//        static let nameAlert: String = "Выберите время события"
//        static let showEvent: String = "Показать событие"
//        static let delete: String = "Удалить"
//        static let chooseAction: String = "Выберите действие"
    }
}

