//
//  FavoriteArtists.swift
//  Artists
//
//  Created by kris on 10/11/2020.
//  Copyright © 2020 kris. All rights reserved.
//

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
