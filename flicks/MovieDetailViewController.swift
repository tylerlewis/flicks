//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Tyler Hackley Lewis on 3/31/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieDetailScrollView: UIScrollView!
    
    @IBOutlet weak var movieDetailView: UIView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieReleseDateLabel: UILabel!
    
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    var movieTitle: String!
    
    var movieReleaseDate: String!
    
    var movieOverview: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

}
