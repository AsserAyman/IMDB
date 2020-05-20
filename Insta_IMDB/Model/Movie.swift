//
//  Movie.swift
//  Insta_IMDB
//
//  Created by Asser on 5/18/20.
//  Copyright © 2020 Asser. All rights reserved.
//

import Foundation
import UIKit

struct MoviesData : Decodable{
    let results : [Movie]
    let total_pages : Int
    let total_results : Int
}

struct Movie : Decodable{
    let title : String
    let poster_path : String
    let release_date : String
    let overview : String
    init(title : String, poster : String, date : String, description : String) {
        self.title = title
        poster_path = poster
        release_date = date
        overview = description
    }
}

