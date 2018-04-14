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
    static func uploadPhoto(_ image: Image) {
        let start = Date()
        let transferManager = AWSS3TransferManager.default()
        
        let fileName = "\(Constants.userID)_\(image.timestamp_ms).jpg"
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("upload").appendingPathComponent(fileName)
        if let jpegData = image.jpegData {
            try! jpegData.write(to: fileURL, options: [.atomic])
        } else {
            print("No jpeg data!?")
            return
        }
        
        guard let uploadRequest = AWSS3TransferManagerUploadRequest() else {
            print("Failed to create upload request")
            return
        }
        uploadRequest.body = fileURL
        uploadRequest.key = fileName
        uploadRequest.bucket = Constants.S3BucketName
        
        transferManager.upload(uploadRequest).continueWith { (task) -> AnyObject? in
            if let error = task.error as NSError? {
                print("upload() failed: [\(error)]")
                // Plenty of useful debug info: https://github.com/awslabs/aws-sdk-ios-samples/blob/master/S3TransferManager-Sample/Swift/S3TransferManagerSampleSwift/UploadViewController.swift#L87
            }
            
            if task.result != nil {
                print("upload successful in \(Date().timeIntervalSince(start))s")
            }
            return nil
        }
    }
}
