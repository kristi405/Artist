import UIKit
import RealmSwift

final class FavoriteCell: UICollectionViewCell {
    // MARK: IBOutlets
    
    @IBOutlet weak var imageFavoriteArtist: UIImageView!
    @IBOutlet weak var labelFavoriteArtist: UILabel!
    
    // MARK: Private Properties
    
    private var artists = try! Realm().objects(FavoriteArtists.self).sorted(byKeyPath: "name", ascending: true)
    
    // MARK:  Public Methods
    
    func configureCell(cell: FavoriteCell, indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        
        cell.labelFavoriteArtist.text = artist.name
        
        guard let dataUrl = URL(string: artist.image ?? "nil") else {return}
        guard let imageData = try? Data(contentsOf: dataUrl) else {return}
        
        cell.imageFavoriteArtist.image = UIImage(data: imageData)
    }
}
