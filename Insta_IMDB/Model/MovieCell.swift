//
//  MovieCell.swift
//  Insta_IMDB
//
//  Created by Asser on 5/18/20.
//  Copyright © 2020 Asser. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
 
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    func setCell(movie: Movie,poster: UIImage){
        movieTitle.text = movie.title
        date.text = movie.release_date
        overview.text = movie.overview
        posterImage.image = poster
    }
}

//Another way of loading image (Not Used)
extension UIImageView{
    func loadImageURL(url : URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
            
        }
    }
}
