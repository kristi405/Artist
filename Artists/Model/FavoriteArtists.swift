import RealmSwift

class FavoriteArtists: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var image: String?
    
    convenience init(name: String?, image: String?) {
        self.init()
        self.name = name
        self.image = image
    }
}
