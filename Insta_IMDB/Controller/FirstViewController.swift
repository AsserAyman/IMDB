//
//  FirstViewController.swift
//  Insta_IMDB
//
//  Created by Asser on 5/18/20.
//  Copyright © 2020 Asser. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var movies : [Movie] = []
    var posters : [UIImage] = []
    var totalMovies = 1
    var totalPages = 1
    var pageNumber = 1
    let urlBase = "https://api.themoviedb.org/3/discover/movie?api_key=acea91d2bff1c53e6604e4985b6989e2&page="
    let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    var indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        showIndicator()
        networking(pageNumber: pageNumber)
    }
    
    //Initial loading indicator
    func activityIndicator() {
        indicator = UIActivityIndicatorView()
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    func showIndicator() {
        DispatchQueue.main.async {
                       self.activityIndicator()
                       self.indicator.startAnimating()
                       self.indicator.backgroundColor = .darkGray
        }
    }
    
    func networking(pageNumber : Int){
        if pageNumber <= totalPages{ //To stop when reaches last page
            let urlString = "\(urlBase)\(pageNumber)"
            if let _ = URL(string: urlString){
                    performRequest(urlString: urlString)
            }
        }
    }
        
    func performRequest(urlString : String){
        //Create a URL
        if let url = URL(string: urlString){
            //Create a URL Session
            let session = URLSession(configuration: .default)
            //Give Session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{ //safeData is data returned from API
                    self.parseJSON(moviesData: safeData)
                }
            }
            task.resume()  //Start a task
        }
    }
    
    func parseJSON(moviesData : Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MoviesData.self, from: moviesData)
            totalPages = decodedData.total_pages
            totalMovies = decodedData.total_results
            let count = decodedData.results.count
            
            //Fetches all movies in the page
            for index in 0 ..< count {
                let temp = decodedData.results[index]
                movies.append(Movie(title: temp.title, poster: temp.poster_path, date: temp.release_date, description: temp.overview))
                
                let url = URL(string: imageBaseURL + temp.poster_path)
                let data = try? Data(contentsOf: url!)
                //Downloads Image
                if let imageData = data {
                   posters.append(UIImage(data: imageData)!)
                }
            }
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.tableView.reloadData()
            }

        } catch {
            print(error)
            //showIndicator()
        }
    }
    
}

 extension FirstViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMoviesCell") as! MovieCell
        cell.setCell(movie: movie,poster: posters[indexPath.row])
        return cell
    }
    
    //Loading Indicator when loading next page
    func loadNextPage(){
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = movies.count-1
        if indexPath.row == lastIndex{
            loadNextPage()
            pageNumber += 1
            networking(pageNumber: pageNumber )
        }
    }
}
