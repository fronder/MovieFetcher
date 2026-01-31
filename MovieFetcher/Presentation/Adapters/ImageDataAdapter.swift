//
//  ImageDataAdapter.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import UIKit

final class ImageDataAdapter {
    static func toUIImage(from imageData: ImageData) -> UIImage? {
        return UIImage(data: imageData.data)
    }
}

