//
//  NowPlayingViewController.swift
//  flicks
//
//  Created by Tyler Hackley Lewis on 3/31/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nowPlayingTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var loadingScreen: UIView?
    
    var newMovies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the refresh control
        refreshControl.addTarget(self, action: #selector(refreshNowPlayingMovies(_:)), for: UIControlEvents.valueChanged)
        nowPlayingTableView.insertSubview(refreshControl, at: 0)
        
        // Show loading state while we fetch the movies
        loadingScreen = UIView(frame: nowPlayingTableView.frame)
        loadingScreen!.backgroundColor = UIColor.black
        loadingScreen!.alpha = 0.8
        nowPlayingTableView.addSubview(loadingScreen!)
        
        getNowPlayingMovies()

        nowPlayingTableView.delegate = self
        nowPlayingTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = nowPlayingTableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        
        // Poster
        let movieDetails = newMovies[indexPath.row]
        if let moviePosterImageUrlString = movieDetails.value(forKeyPath: "poster_path") as? String {
            cell.loadPoster(posterUrl: moviePosterImageUrlString)
        }
        // Title
        cell.movieTitleLabel.text = movieDetails.value(forKeyPath: "title") as? String
        cell.movieTitleLabel.sizeToFit()
        // Overview
        cell.movieOverviewLabel.text = movieDetails.value(forKeyPath: "overview") as? String
        cell.movieOverviewLabel.sizeToFit()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the index path from the cell that was tapped
        let indexPath = nowPlayingTableView.indexPathForSelectedRow
        // Get the Row of the Index Path and set as index
        let index = indexPath?.row
        // Get in touch with the DetailViewController
        let movieDetailViewController = segue.destination as! MovieDetailViewController
        // Pass on the data to the Detail ViewController by setting it's indexPathRow value
        movieDetailViewController.index = index
    }
    
    func getNowPlayingMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        self.newMovies = responseDictionary["results"] as! [NSDictionary]
                        
                        self.nowPlayingTableView.reloadData()
                        
                    }
                }
                self.loadingScreen?.removeFromSuperview()
                
                self.refreshControl.endRefreshing()
            }
        );
        task.resume()
    }
    
    func refreshNowPlayingMovies(_ refreshControl: UIRefreshControl) {
        getNowPlayingMovies()
    }

}
