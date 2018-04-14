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
import Photos

public struct Image {
    public var jpegData: Data?
    public let date: Date
    public var timestamp_ms: Int {
        return Int(self.date.timeIntervalSince1970 * 1000)
    }
    
    public init(_ imageBuffer: CVPixelBuffer, date: Date = Date()) {
        let rawImage = CIImage(cvImageBuffer: imageBuffer).oriented(.right)
//        if let filter = CIFilter(name: "Adam's cool filter") {
//            filter.setValue(rawImage, forKey: "inputImage")
//            filter.setValue(0.5, forKey: "inputScale")
//            filter.setValue(1.0, forKey: "inputAspectRatio")
//            if let scaledImage = filter.value(forKey: "outputImage") as? CIImage {
//
//            }
//        }
        if let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) {
            self.jpegData = CIContext().jpegRepresentation(of: rawImage, colorSpace: colorSpace)
        }
//        if let data = self.jpegData {
//            // Write it to the Photos library.
////            PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
////                print(status)
////            }
////
////            PHPhotoLibrary.shared().performChanges( {
////                let creationRequest = PHAssetCreationRequest.forAsset()
////                creationRequest.addResource(with: PHAssetResourceType.photo, data: data, options: nil)
////            }, completionHandler: { success, error in
////                DispatchQueue.main.async {
////                    print("jpeg save success? \(success). error? \(error)")
////                }
////            })
//            print("got dat jpeg")
//        } else {
//            print("Failed to jpeg encode image")
//        }
        self.date = date
    }
}
