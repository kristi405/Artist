//
//  CurrentArtist.swift
//  Artists
//
//  Created by kris on 06/11/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation

struct CurrentArtist {
    
    let name: String?
    let imageURL: String?

    init?(artist: Artist) {
        name = artist.name
        imageURL = artist.imageURL
    }
}
