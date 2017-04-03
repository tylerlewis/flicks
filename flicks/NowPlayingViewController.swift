//
//  NowPlayingViewController.swift
//  flicks
//
//  Created by Tyler Hackley Lewis on 3/31/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import KVLoading

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nowPlayingTableView: UITableView!
    
    @IBOutlet weak var networkErrorView: UIView!
    
    @IBOutlet weak var retryGetMoviesButton: UIButton!
    
    @IBAction func onRetryGetMoviesButtonTap(_ sender: Any) {
        getNowPlayingMovies(fromRefresh: false)
    }
    
    let refreshControl = UIRefreshControl()
    
    var newMovies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the refresh control
        refreshControl.addTarget(self, action: #selector(refreshNowPlayingMovies(_:)), for: UIControlEvents.valueChanged)
        nowPlayingTableView.insertSubview(refreshControl, at: 0)
        
        getNowPlayingMovies(fromRefresh: false)

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

        let indexPath = nowPlayingTableView.indexPathForSelectedRow
        let index = indexPath?.row
        
        let movieDetails = newMovies[index!]

        let movieDetailViewController = segue.destination as! MovieDetailViewController
    
        movieDetailViewController.movieTitle = movieDetails.value(forKeyPath: "title") as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let movieReleaseDateString = movieDetails.value(forKeyPath: "release_date") as? String
        let movieReleaseDate = dateFormatter.date(from:movieReleaseDateString!)
        dateFormatter.dateFormat = "MMMM d, yyyy"
        movieDetailViewController.movieReleaseDate = dateFormatter.string(from: movieReleaseDate!)
        
        movieDetailViewController.movieOverview = movieDetails.value(forKeyPath: "overview") as? String
        
    }
    
    func getNowPlayingMovies(fromRefresh: Bool) {
        if !fromRefresh {
            KVLoading.show()
        }
        
        self.networkErrorView.isHidden = true
        
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
                if error != nil {
                    self.networkErrorView.isHidden = false
                } else if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        self.newMovies = responseDictionary["results"] as! [NSDictionary]
                        
                        self.nowPlayingTableView.reloadData()
                    }
                }
                
                KVLoading.hide()
                
                if fromRefresh {
                    self.refreshControl.endRefreshing()
                }
            }
        );
        task.resume()
    }
    
    func refreshNowPlayingMovies(_ refreshControl: UIRefreshControl) {
        getNowPlayingMovies(fromRefresh: true)
    }

}
