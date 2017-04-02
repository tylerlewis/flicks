//
//  MovieDetailViewController.swift
//  flicks
//
//  Created by Tyler Hackley Lewis on 3/31/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var movieLabel: UILabel!
    
    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieLabel.text = ("You tapped the cell at index \(index!)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
