//
//  Hour.swift
//  YelpApp
//
//  Created by Bell on 2022-06-27.
//

import Foundation

struct Hour: Decodable {
    var hourOpen: [Open]
    var hoursType: String
    var isOpenNow: Bool

}
