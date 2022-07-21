//
//  BusinessDetailsPresenter.swift
//  YelpApp
//
//  Created by Bell on 2022-07-07.
//

import Foundation
import UIKit
import CoreData

class BusinessDetailsPresenter {
    
    weak var view: BusinessDetailsViewController?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(view: BusinessDetailsViewController) {
        self.view = view
    }
    
    // Create and populate photo album for business if it doesn't already exist
    func createAlbum(for business: Business) {
        // Check if album already exists
        let alias = business.alias
        let predicate = NSPredicate(format: "businessId == %@", alias)
        let request = AlbumEntity.fetchRequest() as NSFetchRequest<AlbumEntity>
        request.predicate = predicate
        let result = try! context.fetch(request)
        
        if result.isEmpty{
            // Create album
            let album = AlbumEntity(context: context)
            album.businessId = alias
            try! context.save()

            // Fetch and save image from URL to Core Data for offline usage
            if let displayImageUrl = business.image_url {
                    if let data = try? Data( contentsOf: URL(string: displayImageUrl)!)
                    {
                        if let image = UIImage(data: data) {
//                            DispatchQueue.main.async {
                                self.storeImage(image: image, key: alias, storageType: .coreData)
                                self.storeImage(image: UIImage(imageLiteralResourceName: "sample-food"), key: alias, storageType: .coreData)
//                            }
                        }
                    }
            }
        }
        
    }
    
    // Save image by business alias name
    func storeImage(image: UIImage, key: String, storageType: StorageType){
        if let pngRepresentation = image.pngData() {
                switch storageType {
                case .fileSystem:
                    if let filePath = FileSystemUtils.filePath(forKey: key) {
                        do  {
                            try pngRepresentation.write(to: filePath,
                                                        options: .atomic)
                        } catch let err {
                            print("Saving file resulted in error: ", err)
                        }
                    }
                case .userDefaults:
                    UserDefaults.standard.set(pngRepresentation, forKey: key)
                    
                case .coreData:
                    // Find album with business alias name
                    let predicate = NSPredicate(format: "businessId == %@", key)
                    let request = AlbumEntity.fetchRequest() as NSFetchRequest<AlbumEntity>
                    request.predicate = predicate
                    let albums = try! context.fetch(request)
                    var album: AlbumEntity? = nil
                    
                    guard !albums.isEmpty else { return }
                    // Save image to retrieved album
                    album = albums[0]
                    let image = ImageEntity(context: context)
                    image.album = album!
                    image.image = pngRepresentation
                    try! context.save()
                    
                    
                }
            }
    }
    
//    func retrieveImage(key: String, storageType: StorageType) -> UIImage? {
//        switch storageType {
//        case .fileSystem:
//            if let filePath = FileSystemUtils.filePath(forKey: key),
//                let fileData = FileManager.default.contents(atPath: filePath.path),
//                let image = UIImage(data: fileData) {
//                return image
//            }
//        case .userDefaults:
//            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
//               let image = UIImage(data: imageData) {
//                    return image
//                }
//        case .coreData:
//            return nil
//        }
//        return nil
//    }
    
    // Get all stored images by business alias name
    func retrieveAllImages(businessAlias: String, storageType: StorageType) -> [UIImage] {

        switch storageType {
        case .userDefaults:
            return []
        
        case .fileSystem:
            var images: [UIImage] = []
            let url = FileSystemUtils.folderPath(businessAlias)!
            let fileManager = FileManager.default

            do {
                let imageURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options:.skipsHiddenFiles)

                for imageUrl in imageURLs {
                    images.append(UIImage(data: try! Data(contentsOf: imageUrl))!)
                }

            } catch let error as NSError {
                print(error.description)
            }
            
            return images
        
        case .coreData:
            let predicate = NSPredicate(format: "businessId == %@", businessAlias)
            let request = AlbumEntity.fetchRequest() as NSFetchRequest<AlbumEntity>
            request.predicate = predicate
            let albums = try! context.fetch(request)
            
            
            guard !albums.isEmpty else { return [UIImage]() }
            
            let album = albums[0]
            var imagesArray = [UIImage]()
            
            for imageEntity in album.images! {
//                let imageData = data.value(forKey: "storedImage") as! Data
                let image = (imageEntity as! ImageEntity).image
                imagesArray.append(UIImage(data: image!)!)
              }
            return imagesArray
            
        }
        

        
    }
    
    
}
