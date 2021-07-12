import UIKit
import RealmSwift

final class FavoriteCell: UICollectionViewCell {
    // MARK: IBOutlets
    
    @IBOutlet weak var imageFavoriteArtist: UIImageView!
    @IBOutlet weak var labelFavoriteArtist: UILabel!

    // MARK:  Public Methods
    
    func configureCell(artist: FavoriteArtists) {
        
        labelFavoriteArtist.text = artist.name
        
        guard let dataUrl = URL(string: artist.image ?? "nil") else {return}
        guard let imageData = try? Data(contentsOf: dataUrl) else {return}
        
        imageFavoriteArtist.image = UIImage(data: imageData)
    }
}
