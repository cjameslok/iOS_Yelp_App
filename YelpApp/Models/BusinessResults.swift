//
//  BusinessResults.swift
//  YelpApp
//
//  Created by Bell on 2022-06-29.
//

import Foundation

struct BusinessResults: Decodable {
    var businesses: [Business]
    var total: Int
}
