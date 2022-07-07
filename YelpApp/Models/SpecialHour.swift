//
//  SpecialHour.swift
//  YelpApp
//
//  Created by Bell on 2022-06-27.
//

import Foundation

struct SpecialHour: Decodable {
    var date: String
    var is_closed: Bool?
    var start, end: String
    var isOvernight: Bool

}
