import UIKit
import RealmSwift

final class SearchViewController: UIViewController {
    
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak private var webButton: UIButton!
    
    // MARK:  Properties
    private var artists = try! Realm().objects(FavoriteArtists.self).sorted(byKeyPath: "name", ascending: true)
    private var networkServices = NetworkServices()
    private var currentArtistFavorite: CurrentArtist?
    private var onComplition: ((CurrentArtist) -> Void)?
    private var favoriteVC = FavoriteArtist()
    private var text: String?
    private lazy var timer = AutosearchTimer {
        self.performSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customBatton()
        searchArtist()
        setupSearchController()
    }
    
    // MARK:  Business logic
    // Add to favorites
    @IBAction private func buttonPressed(_ sender: UIButton) {
        if !isContains() {
            favoriteVC.saveArtist()
            sender.setImage(image: Const.redHeart, leadingAnchor: Const.buttonImageLeadingAnchor, topAnchor: Const.buttonImageTopAnchor, heightAnchor: Const.buttonImageHaight)
            sender.setTitle("Удалить из фаворитов", for: .normal)
        } else {
            favoriteVC.deleteArtistFromButton()
            sender.setImage(image: Const.whiteHeart, leadingAnchor: Const.leadingAnchor, topAnchor: Const.topAnchor, heightAnchor: Const.heightAnchor)
            sender.setTitle("Добавить в фавориты", for: .normal)
        }
    }
    
    @IBAction private func showWeb(_ sender: UIButton) {
        let webVC = WebViewController()
        webVC.eventURL = currentArtistFavorite?.url ?? "Введите url"
        present(webVC, animated: true, completion: nil)
    }
    
    
    // Check if the artist has been added to favorites
    private func isContains() -> Bool {
        for artist in artists {
            if currentArtistFavorite?.name == artist.name {
                return true
            }
        }
        return false
    }
    
    // Send a request to find an artist
    private func searchArtist() {
        self.onComplition = { currentArtist in
            self.favoriteVC.currentArtist = currentArtist
            self.configureView(artist: currentArtist)
        }
    }
    
    //     Customizing the button
    private func customBatton() {
        button.searchVCBattons(button: button)
        webButton.searchVCBattons(button: webButton)
    }
    
    // Displaying artist data on the screen
    private func configureView(artist: CurrentArtist) {
        DispatchQueue.main.async {
            self.label.text = artist.name
        }
        //Get data from url
        DispatchQueue.global().async {
            guard let dataUrl = URL(string: artist.imageURL!) else {return}
            guard let imageData = try? Data(contentsOf: dataUrl) else {return}
            
            DispatchQueue.main.async {
                self.image.image = UIImage(data: imageData)
            }
        }
    }
    
    // MARK:  Business logic
    // Install SearchController
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Нужно ввести имя"
        
        searchController.searchBar.delegate = self
    }
}


// MARK:  Extension UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Checking the number of entered characters in the search string
        searchBar.placeholder = "Нужно ввести имя"
        timer.activate()
        self.text = searchText
    }
    
    private func performSearch() {
        timer.cancel()
        guard let text = self.text else {return}
        if text.count <= Const.searchTextCount {
            label.isHidden = true
            image.isHidden = true
            button.isHidden = true
            webButton.isHidden = true
            self.currentArtistFavorite = nil
        } else {
            label.isHidden = false
            image.isHidden = false
            button.isHidden = false
            webButton.isHidden = false
            self.networkServices.fetchArtist(artist: text, complition: { currentArtist in
                print(text)
                self.onComplition?(currentArtist)
                self.currentArtistFavorite = currentArtist
                DispatchQueue.main.async {
                    if !self.isContains() {
                        self.button.setTitle("Добавить в фавориты", for: .normal)
                        self.button.setImage(image: Const.whiteHeart, leadingAnchor: Const.leadingAnchor, topAnchor: Const.topAnchor, heightAnchor: Const.heightAnchor)
                    } else {
                        self.button.setTitle("Удалить из фаворитов", for: .normal)
                        self.button.setImage(image: Const.redHeart, leadingAnchor: Const.buttonImageLeadingAnchor, topAnchor: Const.buttonImageTopAnchor, heightAnchor: Const.buttonImageHaight)
                    }
                }
            })
        }
    }
}

extension SearchViewController {
    private enum Const {
        static let searchTextCount = 2
        static let buttonImageLeadingAnchor: CGFloat = 9.6
        static let buttonImageTopAnchor: CGFloat = 5.1
        static let buttonImageHaight: CGFloat = 29.6
        static let leadingAnchor: CGFloat = 9.8
        static let topAnchor: CGFloat = 4.9
        static let heightAnchor: CGFloat = 28.5
        static let whiteHeart: UIImage = #imageLiteral(resourceName: "whHeart")
        static let redHeart: UIImage = #imageLiteral(resourceName: "redHeart")
    }
}

