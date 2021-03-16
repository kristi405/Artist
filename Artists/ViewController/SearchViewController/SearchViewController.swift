import UIKit
import Foundation
import RealmSwift

final class SearchViewController: UIViewController {
    
// MARK:  Properties
    private var artists = try! Realm().objects(FavoriteArtists.self).sorted(byKeyPath: "name", ascending: true)
    private var networkServices = NetworkServices()
    private var currentArtistFavorite: CurrentArtist?
    private var onComplition: ((CurrentArtist) -> Void)?
    private var favoriteVC = FavoriteArtist()
    private lazy var timer = AutosearchTimer { [weak self] in self?.performSearch() }
    var text: String?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    enum Numbers: CGFloat {
        case borderWidth = 0.5
        case shadowRadius = 10
        case searchTextCount = 2
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customBatton()
        searchArtist()
        setupSearchController()
    }
    
// MARK:  Business logic
    // Add to favorites
    @IBAction func buttonPressed(_ sender: UIButton) {
        if !isContains() {
            favoriteVC.saveArtist()
            sender.setRedImage()
            sender.setTitle("Удалить из фаворитов", for: .normal)
        } else {
            favoriteVC.deleteArtist()
            sender.setImage()
            sender.setTitle("Добавить в фавориты", for: .normal)
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
    
    // Send a request to find an artist
    private func searchArtist() {
        self.onComplition = { currentArtist in
            self.currentArtistFavorite = currentArtist
            self.favoriteVC.currentArtist = currentArtist
            self.networkServices.fetchArtist(artist: currentArtist.name ?? "Введите имя", complition: { currentArtist in
                self.configureView(artist: currentArtist)
            })
        }
    }
    
    // Customizing the button
    private func customBatton() {
        button.isHidden = true
        button.layer.borderWidth = Numbers.borderWidth.rawValue
        button.layer.shadowColor = UIColor.blue.cgColor
        button.layer.shadowRadius = Numbers.shadowRadius.rawValue
        button.layer.borderColor = UIColor.blue.cgColor
        button.setImage()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func performSearch() {
        timer.cancel()
        guard let text = self.text else {return}
        if text.count <= Int(Numbers.searchTextCount.rawValue) {
            label.isHidden = true
            image.isHidden = true
            button.isHidden = true
            button.setTitle("Добавить в фавориты", for: .normal)
            button.setImage()
        } else {
            label.isHidden = false
            image.isHidden = false
            button.isHidden = false
            self.networkServices.fetchArtist(artist: text, complition: { currentArtist in
                print(text)
                self.onComplition?(currentArtist)
            })
        }
    }
}

