//
//  AlbumEntity+CoreDataProperties.swift
//  YelpApp
//
//  Created by Bell on 2022-07-19.
//
//

import Foundation
import CoreData


extension AlbumEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumEntity> {
        return NSFetchRequest<AlbumEntity>(entityName: "AlbumEntity")
    }

    @NSManaged public var businessId: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension AlbumEntity {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageEntity)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageEntity)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

extension AlbumEntity : Identifiable {

}
