//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Tyler Hackley Lewis on 3/31/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
