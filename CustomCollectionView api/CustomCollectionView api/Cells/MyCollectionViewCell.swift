//
//  MyCollectionViewCell.swift
//  CustomCollectionView api
//
//  Created by Abul Kashem on 13/11/22.
//

import UIKit
import SDWebImage

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
//    nameLabel
//    posterImageView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 20
    }
    
    func configure(movie: Result) {
        if let posterPath = movie.posterPath {
            posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + posterPath), placeholderImage: UIImage(named: "placeholder-image"))
        }
        else {
            posterImageView.image =  UIImage(named: "placeholder-image")
        }
        nameLabel.text = movie.title
        
    }
    
}
