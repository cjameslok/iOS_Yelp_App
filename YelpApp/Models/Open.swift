//
//  Open.swift
//  YelpApp
//
//  Created by Bell on 2022-06-27.
//

import Foundation

struct Open: Decodable {
    var is_overnight: Bool
    var start, end: String
    var day: Int

}
