//
//  BusinessDetailsCell.swift
//  YelpApp
//
//  Created by Bell on 2022-06-30.
//

import UIKit

class BusinessDetailsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var RatingView: UIView!
    @IBOutlet var StarImageCollection: [UIImageView]!
    
//    var business: Business
    var rating: Double?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let rating = self.rating else { return }
        for i in StarImageCollection.indices {
            if (i <= Int(floor(rating))-1){
                StarImageCollection[i].image = UIImage(systemName: "star.fill")
            }
            else if (Double(i) + 0.5 == rating) {
                StarImageCollection[i].image = UIImage(systemName: "star.leadinghalf.fill")
            }
        }

    }
    

    
}
