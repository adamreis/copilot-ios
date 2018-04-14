//
//  Image.swift
//  Copilot
//
//  Created by Adam Reis on 4/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Mapper
import ARKit

public struct Image {
    public var jpegData: Data?
    public let date: Date
    public var timestamp_ms: Int {
        return Int(self.date.timeIntervalSince1970 * 1000)
    }
    
    public init(_ imageBuffer: CVPixelBuffer, date: Date = Date()) {
        let image = CIImage(cvImageBuffer: imageBuffer)
//        self.jpegData = CIContext().jpegRepresentation(of: image, colorSpace: CGColorSpace.sRGB as! CGColorSpace)
        self.jpegData = nil
//        if let data = self.jpegData {
////            // Write it to the Photos library.
////            PHPhotoLibrary.shared().performChanges( {
////                let creationRequest = PHAssetCreationRequest.forAsset()
////                creationRequest.addResource(with: PHAssetResourceType.photo, data: jpegData, options: nil)
////            }, completionHandler: { success, error in
////                DispatchQueue.main.async {
////                    completionHandler?(success, error)
////                }
////            })
//        } else {
//            print("Failed to jpeg encode image")
//        }
        self.date = date
    }
}
