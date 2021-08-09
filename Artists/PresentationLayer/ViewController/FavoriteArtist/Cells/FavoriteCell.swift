import UIKit

final class FavoriteCell: UICollectionViewCell {
    // MARK: IBOutlets
    
    @IBOutlet private weak var imageFavoriteArtist: UIImageView!
    @IBOutlet private weak var labelFavoriteArtist: UILabel!

    // MARK:  Public Methods
    
    func configureCell(artist: FavoriteArtists) {
        labelFavoriteArtist.text = artist.name
        
        guard let dataUrl = URL(string: artist.image ?? "name") else {return}
        guard let imageData = try? Data(contentsOf: dataUrl) else {return}
        
        imageFavoriteArtist.image = UIImage(data: imageData)
    }
}
