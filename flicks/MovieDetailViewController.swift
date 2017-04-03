//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Tyler Hackley Lewis on 3/31/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var movieDetailContainerView: UIView!
    
    @IBOutlet weak var movieDetailScrollView: UIScrollView!
    
    @IBOutlet weak var movieDetailView: UIView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieReleseDateLabel: UILabel!
    
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    var posterUrl: String!
    
    var movieTitle: String!
    
    var movieReleaseDate: String!
    
    var movieOverview: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundImage()
        
        movieTitleLabel.text = movieTitle ?? ""
        movieReleseDateLabel.text = movieReleaseDate ?? ""
        movieOverviewLabel.text = movieOverview ?? ""
        movieOverviewLabel.sizeToFit()
        
        // Resize the movieDetailView based on size of overview label
        movieDetailView.frame.size = CGSize(width: movieDetailView.frame.width, height: movieDetailView.frame.height + movieOverviewLabel.frame.height)
        
        let heightMultiple = Float(1 + (movieOverviewLabel.numberOfLines / 20))
        let contentWidth = movieDetailScrollView.bounds.width
        let contentHeight = Float(movieDetailScrollView.bounds.height) * heightMultiple
        movieDetailScrollView.contentSize = CGSize(width: contentWidth, height: CGFloat(contentHeight))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setBackgroundImage() {
        // TODO - Figure out how to get the image from cache
        let posterUrlString: String! = "https://image.tmdb.org/t/p/w342\(self.posterUrl!)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"

        let url = URL(string: posterUrlString)
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
                    let poster = UIImage(data: data)
                    self.movieDetailContainerView.backgroundColor = UIColor(patternImage: poster!)
                }
            }
        );
        task.resume()
    }

}
