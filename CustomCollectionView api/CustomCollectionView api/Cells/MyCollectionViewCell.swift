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
    @IBOutlet weak var viewsName: UILabel!
    
    //    nameLabel
//    posterImageView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 10
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        posterImageView.layer.cornerRadius = posterImageView.bounds.width/2.0
//
//    }
    
    func configure(movie: Result) {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        if let posterPath = movie.posterPath {
            posterImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + posterPath), placeholderImage: UIImage(named: "placeholder-image"))
        }
        else {
            posterImageView.image =  UIImage(named: "placeholder-image")
        }
        nameLabel.text = movie.title
        viewsName.text = String(movie.id!)
    }
}
