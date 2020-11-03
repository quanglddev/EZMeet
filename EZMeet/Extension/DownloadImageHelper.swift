//
//  DownloadImageHelper.swift
//  EZMeet
//
//  Created by QUANG on 7/29/17.
//  Copyright © 2017 EZSolution. All rights reserved.
//

import UIKit

extension UserDefaults {
    func set(image: UIImage?, forKey key: String) {
        guard let image = image else {
            set(nil, forKey: key)
            return
        }
        set(image.jpegData(compressionQuality: 1.0), forKey: key)
    }
    func image(forKey key:String) -> UIImage? {
        guard let data = data(forKey: key), let image = UIImage(data: data )
            else  { return nil }
        return image
    }
    func set(imageArray value: [UIImage]?, forKey key: String) {
        guard let value = value else {
            set(nil, forKey: key)
            return
        }
        set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
    }
    func imageArray(forKey key:String) -> [UIImage]? {
        guard let data = data(forKey: key), let imageArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UIImage] else
        { return nil }
        return imageArray
    }
}
