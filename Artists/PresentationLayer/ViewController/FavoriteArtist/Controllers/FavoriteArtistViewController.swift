import UIKit
import RealmSwift

final class FavoriteArtist: UICollectionViewController {
    // MARK:  Private Properties
    
    private var artists = try? Realm().objects(FavoriteArtists.self).sorted(byKeyPath: Constants.keyPathName, ascending: true)
    private var networkServices = NetworkServices()
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
        
        navigationController?.navigationBar.barTintColor = Constants.color
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.backgroundColor = Constants.color
    }
    
    // MARK: IBActions
    
    // Choosing an option for a favorite
    private func showAlert(artist: FavoriteArtists) {
        let attributedString = NSAttributedString(string: artist.name ?? Constants.all,
                                                  attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        let ac = UIAlertController(title: nil, message: Constants.chooseAction, preferredStyle: .alert)
        ac.setValue(attributedString, forKey: Constants.atributedStringKey)
        
        let showDetale = UIAlertAction(title: Constants.showEvent, style: .default) { show in
            self.showAlertEvent(artist: artist)
        }
        
        let deleteAction = UIAlertAction(title: Constants.delete, style: .default) { delete in
            self.deleteFavoriteArtist(artist: artist)
        }
        
        let cencelButton = UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil)
        
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
            mapVC.events = currentEvents
            self.performSegue(withIdentifier: Constants.segueIdentifire, sender: self)
            guard let annotation = mapVC.annotations else {return}
            mapVC.mapView.removeAnnotations(annotation)
        }
    }
    
    // Сhoose the time of the event: all, past, upcoming
    private func showAlertEvent(artist: FavoriteArtists) {
        let attributedString = NSAttributedString(string: artist.name ?? Constants.all,
                                                  attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .largeTitle), NSAttributedString.Key.foregroundColor: UIColor.black])
        let alertEvent = UIAlertController(title: artist.name, message: Constants.nameAlert, preferredStyle: .actionSheet)
        alertEvent.setValue(attributedString, forKey: Constants.atributedStringKey)
        
        let allEvent = UIAlertAction(title: Constants.allEvents, style: .default) { _ in
            self.networkServices.fetchEvent(artist: artist.name ?? Constants.all, date: Constants.all) { currentEvent in
                self.events = currentEvent
                self.sentEvents(currentEvents: currentEvent)
            }
        }
        let pastEvent = UIAlertAction(title: Constants.pastEvents, style: .default) { (past) in
            self.networkServices.fetchEvent(artist: artist.name ?? Constants.all, date: Constants.past) { currentEvent in
                self.events = currentEvent
                self.sentEvents(currentEvents: currentEvent)
            }
        }
        let upcomingEvent = UIAlertAction(title: Constants.upcomingEvents, style: .default) { (upcoming) in
            self.networkServices.fetchEvent(artist: artist.name ?? Constants.all, date: Constants.upcoming) { currentEvent in
                self.events = currentEvent
                self.sentEvents(currentEvents: currentEvent)
            }
        }
        
        let cencelButton = UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil)
        
        alertEvent.addAction(allEvent)
        alertEvent.addAction(pastEvent)
        alertEvent.addAction(upcomingEvent)
        alertEvent.addAction(cencelButton)
        
        alertEvent.view.addSubview(UIView())
        present(alertEvent, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueIdentifire {
            let eventVC = segue.destination as! EventVC
            guard let events = self.events else {return}
            eventVC.events = events
        }
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
        guard let artists = artists else {return 1}
        return artists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifire, for: indexPath)
        
        if let favoriteArtistCell = cell as? FavoriteCell {
            guard let artists = self.artists else {return favoriteArtistCell}
            let artist = artists[indexPath.row]
            
            favoriteArtistCell.configureCell(artist: artist)
        }
        return cell
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
        static let atributedStringKey = "attributedTitle"
        static let cellIdentifire = "FavoriteCell"
        static let segueIdentifire = "showEvent"
        static let keyPathName = "name"
        static let cellSpacingVertical: CGFloat = 30.0
        static var widthItem: CGFloat = .zero
        static let item: CGFloat = 2.0
        static let cellSpasing: CGFloat = 40
        static let spasingBetweenItems: CGFloat = 20
        static let one: CGFloat = 1
        static let color = UIColor(named: "Color")
        static let allEvents: String = "Все"
        static let pastEvents: String = "Прошедшие"
        static let upcomingEvents: String = "Предстоящие"
        static let all: String = "all"
        static let past: String = "past"
        static let upcoming: String = "upcoming"
        static let cancel: String = "Отмена"
        static let nameAlert: String = "Выберите время события"
        static let showEvent: String = "Показать событие"
        static let delete: String = "Удалить"
        static let chooseAction: String = "Выберите действие"
    }
}

