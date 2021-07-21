import UIKit
import RealmSwift

final class SearchViewController: UIViewController {
    // MARK: IBOutlets
    
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var webButton: UIButton!
    
    // MARK: Private Properties
    
    private var artists = try? Realm().objects(FavoriteArtists.self).sorted(byKeyPath: Constants.keyPathName, ascending: true)
    private var networkServices = NetworkServices()
    private var currentArtistFavorite: CurrentArtist?
    private var onComplition: ((CurrentArtist) -> Void)?
    private var favoriteVC = FavoriteArtist()
    private var text: String?
    private lazy var timer = AutosearchTimer {
        self.performSearch()
    }
    private var searchController = UISearchController()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.backgroundColor
        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        tabBarController?.tabBar.barTintColor = Constants.tabBarColor
        image.contentMode = .scaleAspectFit
        customBatton()
        searchArtist()
        setupSearchController()
    }
    
    // MARK: Navigations segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segueIdentifire {
            let webVC = segue.destination as! WebViewController
            webVC.eventURL = currentArtistFavorite?.url ?? Constants.enterURL
        }
    }
    
    // MARK: Actions with buttons
    
    // Add to favorites
    @IBAction private func buttonPressed(_ sender: UIButton) {
        if !isContains() {
            favoriteVC.saveArtist()
            sender.setImage(image: Constants.redHeart, leadingAnchor: Constants.leadingAnchorOfImage, heightAnchor: Constants.heightAnchorOfImage)
            sender.setTitle(Constants.removeFromFavorits, for: .normal)
        } else {
            favoriteVC.deleteArtistFromButton()
            sender.setImage(image: Constants.whiteHeart, leadingAnchor: Constants.leadingAnchorOfImage, heightAnchor: Constants.heightAnchorOfImage)
            sender.setTitle(Constants.addToFavorits, for: .normal)
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
            guard let dataUrl = URL(string: artist.imageURL ?? Constants.enterURL) else {return}
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
        searchController.searchBar.placeholder = Constants.enterTheName
        searchController.searchBar.searchTextField.backgroundColor = .white
        self.searchController = searchController
        
        searchController.searchBar.delegate = self
    }
    
    // Hidden or not hidden labels
    private func labelIsHidden() {
        label.isHidden = true
        image.isHidden = true
        button.isHidden = true
        webButton.isHidden = true
    }
    
    private func labelIsNotHidden() {
        label.isHidden = false
        image.isHidden = false
        button.isHidden = false
        webButton.isHidden = false
    }
    
    // we check is the artist conteins in Realm
    private func checkArtistsConteins() {
        if !isContains() {
            button.setTitle(Constants.addToFavorits, for: .normal)
            button.setImage(image: Constants.whiteHeart, leadingAnchor: Constants.leadingAnchorOfImage, heightAnchor: Constants.heightAnchorOfImage)
        } else {
            button.setTitle(Constants.removeFromFavorits, for: .normal)
            button.setImage(image: Constants.redHeart, leadingAnchor: Constants.leadingAnchorOfImage, heightAnchor: Constants.heightAnchorOfImage)
        }
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
        if text.count == .zero {
            self.searchController.searchBar.placeholder = Constants.enterTheName
        } else if text.count <= Constants.searchTextCount {
            self.searchController.searchBar.searchTextField.text = Constants.enterTheName
            labelIsHidden()
            self.currentArtistFavorite = nil
        } else {
            self.networkServices.fetchArtist(artist: text, complition: { currentArtist in
                self.onComplition?(currentArtist)
                self.currentArtistFavorite = currentArtist
                DispatchQueue.main.async {
                    self.labelIsNotHidden()
                    self.checkArtistsConteins()
                }
            })
        }
    }
}

// MARK: - Constants
extension SearchViewController {
    private enum Constants {
        static let enterURL = "Введите url"
        static let segueIdentifire = "showWebView"
        static let keyPathName = "name"
        static let searchTextCount = 2
        static let addToFavorits = "Добавить в фавориты"
        static let removeFromFavorits = "Удалить из фаворитов"
        static let enterTheName = "Нужно ввести имя"
        static let leadingAnchorOfImage: CGFloat = -4
        static let heightAnchorOfImage: CGFloat = 28
        static let whiteHeart: UIImage = #imageLiteral(resourceName: "whHeart")
        static let redHeart: UIImage = #imageLiteral(resourceName: "redHeart1")
        static let backgroundColor = UIColor(named: "Color")
        static let tabBarColor = UIColor(named: "BackgroundColor")
    }
}

