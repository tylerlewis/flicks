//
//  MovieTableViewCell.swift
//  flicks
//
//  Created by Tyler Hackley Lewis on 3/31/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import AFNetworking

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    func loadPoster(posterUrl: String!) {
        let posterUrlString: String! = "https://image.tmdb.org/t/p/w342\(posterUrl!)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        if let posterUrl = URL(string: posterUrlString) {
            self.movieImageView.setImageWith(posterUrl)
        }
    }
}
