//
//  ImageEntity+CoreDataProperties.swift
//  YelpApp
//
//  Created by Bell on 2022-07-19.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var image: Data?
    @NSManaged public var album: AlbumEntity?

}

extension ImageEntity : Identifiable {

}
