//
//  Hour.swift
//  YelpApp
//
//  Created by Bell on 2022-06-27.
//

import Foundation

struct Hour: Decodable {
    var hour_open: [Open]
    var hours_type: String
    var is_open_now: Bool

}
