//
//  Business.swift
//  YelpApp
//
//  Created by Bell on 2022-06-27.
//

import Foundation

struct Business: Decodable {
    var id, alias, name: String
    var imageURL: String?
    var isClaimed, isClosed: Bool?
    var url: String?
    var phone, displayPhone: String?
    var reviewCount: Int?
    var categories: [Category]?
    var rating: Double?
    var location: Location?
    var coordinates: Coordinates?
    var photos: [String]?
    var price: String?
    var hours: [Hour]?
//    var transactions: [Any]
    var specialHours: [SpecialHour]?

    
}
