//
//  SecondViewController.swift
//  Insta_IMDB
//
//  Created by Asser on 5/18/20.
//  Copyright © 2020 Asser. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController , AddMovie{
   
    @IBOutlet weak var tableView: UITableView!
    var movies : [Movie] = []
    var posters : [UIImage] = []
        
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.reloadData()
        super.viewDidLoad()
        
    }
    func addData(movie : Movie,poster : UIImage) {
        movies.append(movie)
        posters.append(poster)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}


 extension SecondViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMoviesCell") as! MovieCell
        cell.setCell(movie: movie,poster: posters[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! AddMovieViewController
        viewController.delegate = self
    }
}
