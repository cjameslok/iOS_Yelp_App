//
//  FileSystemUtils.swift
//  YelpApp
//
//  Created by Bell on 2022-07-19.
//

import Foundation

class FileSystemUtils {
    
    static func filePath(forKey key: String) -> URL? {
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
    
    static func folderPath(_ folderName: String) -> URL? {
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
