//
//  HeadPositionManager.swift
//  Copilot
//
//  Created by Adam Reis on 4/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import ARKit

private let kHeadPositionSampleRateMs = 100
private let kMaxHeadPositionSamples = 300 // 30s

private let kImageSampleRateMs = 333
private let kMaxImages = 300 // 100s

func heapSize(_ obj: AnyObject) -> Int {
    return malloc_size(Unmanaged.passRetained(obj).toOpaque())
}

class HeadPositionManager {
    static let sharedInstance = HeadPositionManager()
    var headPositions: [Transform] = []
    var cameraPositions: [Transform] = []
    var cameraImages: [Image] = []
    let launchTime = Date()
    var totalHeadPositions = 0
    
    private init() {}
    
    public func addHeadPosition(headPosition: Transform) {
        let noHeadPositions: Bool = self.headPositions.isEmpty
        let noRecentHeadPosition: Bool = (self.headPositions.last?.timestamp_ms ?? 0) + kHeadPositionSampleRateMs < headPosition.timestamp_ms
        
        if noHeadPositions || noRecentHeadPosition {
            self.headPositions.append(headPosition)
        }
        
        if self.headPositions.count > kMaxHeadPositionSamples {
            self.headPositions.removeFirst()
        }
    }
    
    public func addFrame(_ frame: ARFrame) {
        if self.headPositions.count <= self.cameraPositions.count {
            return
        }

        let transform = Transform(frame.camera.transform)
        self.cameraPositions.append(transform)
        if self.cameraPositions.count > kMaxHeadPositionSamples {
            self.cameraPositions.removeFirst()
        }
        
        let noRecentImage: Bool = (self.cameraImages.last?.timestamp_ms ?? 0) + kImageSampleRateMs < transform.timestamp_ms
        if noRecentImage {
            let image = Image(frame.capturedImage)
            self.cameraImages.append(image)
            if self.cameraImages.count > kMaxImages {
                self.cameraImages.removeFirst()
            }
//            if self.cameraPositions.count == 1 {
//                S3Client.uploadPhoto(image)
//            }
//            print("num images: \(self.cameraImages.count)")
        }
    }
    
    public func clear() {
        self.headPositions.removeAll()
        self.cameraPositions.removeAll()
    }
    
    public func uploadImagesBetween(start: Date, end: Date) {
        let matchingPhotos = self.cameraImages.filter { $0.date > start && $0.date < end }
        if matchingPhotos.isEmpty{
            print("ERROR. How the hell did we have an incident without photos?")
            return
        }
        
        let incidentId: String = "\(Int(start.timeIntervalSince1970 * 1000))"
        S3Client.uploadPhotos(matchingPhotos) { urls in
            print("Successfully uploaded photos: \(urls)")
            HTTPClient.reportIncident(urls: urls, incident_id: incidentId)
        }
    }
}
