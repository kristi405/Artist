import UIKit
import RealmSwift

final class SearchViewController: UIViewController {
    // MARK: IBOutlets
    
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak private var webButton: UIButton!
    
    // MARK: Private Properties
    
    private var artists = try! Realm().objects(FavoriteArtists.self).sorted(byKeyPath: "name", ascending: true)
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
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.tabBar.barTintColor = Const.tabBarColor
        image.contentMode = .scaleAspectFill
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
            sender.setTitle("Удалить из фаворитов", for: .normal)
        } else {
            favoriteVC.deleteArtistFromButton()
            sender.setImage(image: Const.whiteHeart, leadingAnchor: Const.leadingAnchor, heightAnchor: Const.heightAnchor)
            sender.setTitle("Добавить в фавориты", for: .normal)
        }
    }
    
    // Show web screan
    @IBAction private func showWeb(_ sender: UIButton) {
        let webVC = WebViewController()
        webVC.eventURL = currentArtistFavorite?.url ?? "Введите url"
        present(webVC, animated: true, completion: nil)
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
            guard let dataUrl = URL(string: artist.imageURL!) else {return}
            guard let imageData = try? Data(contentsOf: dataUrl) else {return}
            
            DispatchQueue.main.async {
                self.image.image = UIImage(data: imageData)
            }
        }
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
        searchController.searchBar.placeholder = "Нужно ввести имя"
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
                print(text)
                self.onComplition?(currentArtist)
                self.currentArtistFavorite = currentArtist
                DispatchQueue.main.async {
                    self.label.isHidden = false
                    self.image.isHidden = false
                    self.button.isHidden = false
                    self.webButton.isHidden = false
                    if !self.isContains() {
                        self.button.setTitle("Добавить в фавориты", for: .normal)
                        self.button.setImage(image: Const.whiteHeart, leadingAnchor: Const.leadingAnchor, heightAnchor: Const.heightAnchor)
                    } else {
                        self.button.setTitle("Удалить из фаворитов", for: .normal)
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
        static let leadingAnchor: CGFloat = -4
        static let heightAnchor: CGFloat = 28
        static let whiteHeart: UIImage = #imageLiteral(resourceName: "whHeart")
        static let redHeart: UIImage = #imageLiteral(resourceName: "redHeart1")
        static let color = #colorLiteral(red: 0.828555796, green: 0.9254013334, blue: 1, alpha: 1)
        static let tabBarColor = #colorLiteral(red: 0.678006619, green: 0.8272836034, blue: 0.9998829961, alpha: 1)
    }
}

