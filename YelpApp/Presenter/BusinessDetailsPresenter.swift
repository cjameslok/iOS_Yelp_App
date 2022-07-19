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
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func createAlbum(for business: Business) {
        let alias = business.alias
        let predicate = NSPredicate(format: "businessId == %@", alias)
        let request = AlbumEntity.fetchRequest() as NSFetchRequest<AlbumEntity>
        request.predicate = predicate
        let result = try! context.fetch(request)

        if result.isEmpty{
            
            let album = AlbumEntity(context: context)
            album.businessId = alias
            try! context.save()
        
            if let displayImageUrl = business.image_url {
                    if let data = try? Data( contentsOf: URL(string: displayImageUrl)!)
                    {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.store(image: image, key: alias, storageType: .coreData)
                                self.store(image: UIImage(imageLiteralResourceName: "sample-food"), key: alias, storageType: .coreData)
                            }
                        }
                    }
            }
        }
        
    }
    
    func store(image: UIImage, key: String, storageType: StorageType){
        if let pngRepresentation = image.pngData() {
                switch storageType {
                case .fileSystem:
                    if let filePath = filePath(forKey: key) {
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
                    let predicate = NSPredicate(format: "businessId == %@", key)
                    let request = AlbumEntity.fetchRequest() as NSFetchRequest<AlbumEntity>
                    request.predicate = predicate
                    let albums = try! context.fetch(request)
                    var album: AlbumEntity? = nil
                    
                    if albums.isEmpty {
                        album = createAlbum(key)
                    } else {
                        album = albums[0]
                    }
                    
                    let image = ImageEntity(context: context)
                    image.album = album!
                    image.image = pngRepresentation
                    try! context.save()
                    
                }
            }
    }
    
    func createAlbum(_ albumName: String) -> AlbumEntity {
        let album = AlbumEntity(context: context)
        album.businessId = albumName
        try! context.save()
        return album
    }
    
    func retrieveImage(key: String, storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
                let fileData = FileManager.default.contents(atPath: filePath.path),
                let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
               let image = UIImage(data: imageData) {
                    return image
                }
        case .coreData:
            return nil
        }
        return nil
    }
    
    func retrieveAllImages(folderName: String, storageType: StorageType) -> [UIImage] {

        switch storageType {
        case .userDefaults:
            return []
        
        case .fileSystem:
            var images: [UIImage] = []
            let url = folderPath(folderName)!
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
            let predicate = NSPredicate(format: "businessId == %@", folderName)
            let request = AlbumEntity.fetchRequest() as NSFetchRequest<AlbumEntity>
            request.predicate = predicate
            let albums = try! context.fetch(request)
            
            
            guard !albums.isEmpty else { return [UIImage]() }
            
            let album = albums[0]
            var imagesArray = [UIImage]()
            
            for imageEntity in album.images! {
//                let imageData = data.value(forKey: "storedImage") as! Data
                let image = (imageEntity as! ImageEntity).image
                imagesArray.append(UIImage(data: image as! Data)!)
              }
            return imagesArray
            
        }
        

        
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        let yelpFolderURL = documentURL.appendingPathComponent("YelpFiles")
        do {
            try fileManager.createDirectory(
                at: yelpFolderURL,
                withIntermediateDirectories: true,
                attributes: nil)
        }
        catch {
            print(error)
        }
        
        let businessFolderURL = yelpFolderURL.appendingPathComponent(key)
        do {
            try fileManager.createDirectory(
                at: businessFolderURL,
                withIntermediateDirectories: true,
                attributes: nil)
        }
        catch {
            print(error)
        }
        
        let count = try! fileManager.contentsOfDirectory(at: businessFolderURL, includingPropertiesForKeys: nil, options:.skipsHiddenFiles).count
        
        
        return businessFolderURL.appendingPathComponent(key + String(count+1) + ".png")
    }
    
    private func folderPath(_ folderName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        let yelpFolderURL = documentURL.appendingPathComponent("YelpFiles")
        do {
            try fileManager.createDirectory(
                at: yelpFolderURL,
                withIntermediateDirectories: true,
                attributes: nil)
        }
        catch {
            print(error)
        }
        
        let businessFolderURL = yelpFolderURL.appendingPathComponent(folderName)
        do {
            try fileManager.createDirectory(
                at: businessFolderURL,
                withIntermediateDirectories: true,
                attributes: nil)
        }
        catch {
            print(error)
        }
        
        
        return businessFolderURL
    }
    
    
}
