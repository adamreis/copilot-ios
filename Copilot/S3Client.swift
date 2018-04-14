//
//  S3Client.swift
//  Copilot
//
//  Created by Adam Reis on 4/14/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import AWSS3

struct S3Client {
    static var uploadMap: [Int: [String: Bool?]] = [:]
    static var pendingUploads: [String] = []
    static var successfulUploads: [String] = []
    
    static func uploadPhotos(_ images: [Image], finished: @escaping ([String]) -> Void) {
        images.forEach { image in
            let fileName = "\(Constants.userID)_\(image.timestamp_ms).jpg"
            pendingUploads.append(fileName)
            self.uploadPhoto(image, fileName: fileName) { success in
                pendingUploads = pendingUploads.filter { $0 != fileName }
                if success {
                    successfulUploads.append(Constants.S3BasePath + fileName)
                }
                if pendingUploads.isEmpty {
                    finished(successfulUploads)
                    successfulUploads = []
                }
                
//                uploadMap[uploadKey]![fileName] = success
//                let unfinished = uploadMap[uploadKey]!.filter { name, status in
//                    status == nil
//                }
//
//                if unfinished.count == 0 {
//                    var succeeded: [String] = []
//                    for (name, status) in uploadMap[uploadKey]! {
//                        if status == true {
//                            succeeded.append(Constants.S3BasePath + name)
//                        }
//                    }
//                    print("\(succeeded.count) succeeded; \(uploadMap[uploadKey]!.count - succeeded.count) failed")
//                    uploadMap[uploadKey] = nil
//                    finished(succeeded)
//                }
            }
        }
        
    }
    
    static func uploadPhoto(_ image: Image, fileName: String, success: @escaping (Bool) -> Void) {
        let start = Date()
        let transferManager = AWSS3TransferManager.default()
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("upload").appendingPathComponent(fileName)
        if let jpegData = image.jpegData {
            try! jpegData.write(to: fileURL, options: [.atomic])
        } else {
            print("No jpeg data!?")
            success(false)
            return
        }
        
        guard let uploadRequest = AWSS3TransferManagerUploadRequest() else {
            print("Failed to create upload request")
            success(false)
            return
        }
        uploadRequest.body = fileURL
        uploadRequest.key = fileName
        uploadRequest.bucket = Constants.S3BucketName
        
        transferManager.upload(uploadRequest).continueWith { (task) -> AnyObject? in
            if let error = task.error as NSError? {
                print("upload() failed: [\(error)]")
                // Plenty of useful debug info: https://github.com/awslabs/aws-sdk-ios-samples/blob/master/S3TransferManager-Sample/Swift/S3TransferManagerSampleSwift/UploadViewController.swift#L87
                success(false)
            }
            
            if task.result != nil {
                print("upload successful in \(Date().timeIntervalSince(start))s")
                success(true)
            } else {
                success(false)
            }
            return nil
        }
    }
}
