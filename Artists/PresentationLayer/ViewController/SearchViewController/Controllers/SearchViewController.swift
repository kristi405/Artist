import UIKit
import RealmSwift

final class SearchViewController: UIViewController {
    // MARK: IBOutlets
    
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak private var webButton: UIButton!
    
    // MARK: Private Properties
    
    private var artists = try? Realm().objects(FavoriteArtists.self).sorted(byKeyPath: "name", ascending: true)
    private var networkServices = NetworkServices()
    private var currentArtistFavorite: CurrentArtist?
    private var onComplition: ((CurrentArtist) -> Void)?
    private var favoriteVC = FavoriteArtist()
    private var text: String?
    private lazy var timer = AutosearchTimer {
        self.performSearch()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Const.color
        navigationController?.navigationBar.barTintColor = Const.color
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        tabBarController?.tabBar.barTintColor = Const.tabBarColor
        image.contentMode = .scaleAspectFit
        customBatton()
        searchArtist()
        setupSearchController()
    }
    
    // MARK: Actions with buttons
    
    // Add to favorites
    @IBAction private func buttonPressed(_ sender: UIButton) {
        if !isContains() {
            favoriteVC.saveArtist()
            sender.setImage(image: Const.redHeart, leadingAnchor: Const.leadingAnchor, heightAnchor: Const.heightAnchor)
            sender.setTitle(Const.removeFromFavorits, for: .normal)
        } else {
            favoriteVC.deleteArtistFromButton()
            sender.setImage(image: Const.whiteHeart, leadingAnchor: Const.leadingAnchor, heightAnchor: Const.heightAnchor)
            sender.setTitle(Const.addToFavorits, for: .normal)
        }
    }
    
    // MARK: Navigations segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            let webVC = segue.destination as! WebViewController
            webVC.eventURL = currentArtistFavorite?.url ?? "Введите url"
        }
    }
    
    // MARK: BusinessLogic
    
    // Send a request to find an artist
    private func searchArtist() {
        self.onComplition = { currentArtist in
            self.favoriteVC.currentArtist = currentArtist
            self.configureView(artist: currentArtist)
        }
    }
    
    // Displaying artist data on the screen
    private func configureView(artist: CurrentArtist) {
        DispatchQueue.main.async {
            self.label.text = artist.name
        }
        //Get data from url
        DispatchQueue.global().async {
            guard let dataUrl = URL(string: artist.imageURL ?? "url") else {return}
            guard let imageData = try? Data(contentsOf: dataUrl) else {return}
            
            DispatchQueue.main.async {
                self.image.image = UIImage(data: imageData)
            }
        }
    }
    
    // Check if the artist has been added to favorites
    private func isContains() -> Bool {
        guard let artists = artists else {return true}
        for artist in artists {
            if currentArtistFavorite?.name == artist.name {
                return true
            }
        }
        return false
    }
    
    // Customizing the button
    private func customBatton() {
        button.searchVCBattons(button: button)
        webButton.searchVCBattons(button: webButton)
    }
    
    // MARK: Setup UISearchController
    
    // Install SearchController
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Const.enterTheName
        searchController.searchBar.searchTextField.backgroundColor = .white
        
        searchController.searchBar.delegate = self
    }
}


// MARK: - Extension UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Checking the number of entered characters in the search string
        timer.activate()
        self.text = searchText
    }
    
    // logic of request artist and view of search screan
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
            self.networkServices.fetchArtist(artist: text, complition: { currentArtist in
                self.onComplition?(currentArtist)
                self.currentArtistFavorite = currentArtist
                DispatchQueue.main.async {
                    self.label.isHidden = false
                    self.image.isHidden = false
                    self.button.isHidden = false
                    self.webButton.isHidden = false
                    if !self.isContains() {
                        self.button.setTitle(Const.addToFavorits, for: .normal)
                        self.button.setImage(image: Const.whiteHeart, leadingAnchor: Const.leadingAnchor, heightAnchor: Const.heightAnchor)
                    } else {
                        self.button.setTitle(Const.removeFromFavorits, for: .normal)
                        self.button.setImage(image: Const.redHeart, leadingAnchor: Const.leadingAnchor, heightAnchor: Const.heightAnchor)
                    }
                }
            })
        }
    }
}

// MARK: - Constants
extension SearchViewController {
    private enum Const {
        static let searchTextCount = 2
        static let addToFavorits = "Добавить в фавориты"
        static let removeFromFavorits = "Удалить из фаворитов"
        static let enterTheName = "Нужно ввести имя"
        static let leadingAnchor: CGFloat = -4
        static let heightAnchor: CGFloat = 28
        static let whiteHeart: UIImage = #imageLiteral(resourceName: "whHeart")
        static let redHeart: UIImage = #imageLiteral(resourceName: "redHeart1")
        static let color = UIColor(named: "Color")
        static let tabBarColor = UIColor(named: "BackgroundColor")
    }
}

