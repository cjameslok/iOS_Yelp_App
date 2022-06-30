//
//  BusinessDetailsCell.swift
//  YelpApp
//
//  Created by Bell on 2022-06-30.
//

import UIKit

class BusinessDetailsCell: UITableViewCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var starsHStack: UIStackView!
    
    @IBOutlet weak var RatingView: UIView!

    @IBOutlet weak var star1Image: UIImageView!
    
    
    
//    @IBOutlet weak var starImage: UIImageView!
    var rating = 0
    var maximumRating = 5
    var offImage: UIImage?
    var onImage = UIImage(systemName: "star.fill")
    var offColor = UIColor.gray
    var onColor = UIColor.yellow
    
//    fileprivate let ratingView: UIView = {
//        let v = UIView()
//        v.translatesAutoresizingMaskIntoConstraints = false
////        v.clipsToBounds = true
////        v.backgroundColor = ColorManager.creamColor
////        v.layer.cornerRadius = 5
//        v.addSubview(onImage)
//
//        return v
//    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        star1Image.image = UIImage(systemName:"star.fill")
    }
    

    
}
