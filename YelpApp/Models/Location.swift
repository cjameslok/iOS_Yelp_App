//
//  Location.swift
//  YelpApp
//
//  Created by Bell on 2022-06-27.
//

import Foundation

struct Location: Decodable {
    var address1, address2, address3, city: String?
    var zip_code, country, state: String?
    var display_address: [String]?
    var cross_streets: String?
}
