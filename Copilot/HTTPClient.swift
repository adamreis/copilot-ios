//
//  HTTPClient.swift
//  Copilot
//
//  Created by Adam Reis on 4/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private extension Transform {
    func toDictionary() -> [String: Any] {
        return [
            "position": [
                self.transform[0].map { $0 as Float},
                self.transform[1].map { $0 as Float},
                self.transform[2].map { $0 as Float},
                self.transform[3].map { $0 as Float},
            ],
            "time_ms": self.timestamp_ms
        ]
    }
}

private extension ULU {
    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            "user_id": 1,
            "head_positions": self.headPositions.isEmpty ? [] : [self.headPositions.map { $0.toDictionary() }.last!],
            "camera_positions": self.cameraPositions.isEmpty ? [] : [self.cameraPositions.map { $0.toDictionary() }.last!],
            "location": [
                "lat": 37.386251,
                "lng": -122.0668649,
                "altitude_m": 50.2,
                "speed_mps": 15.64,
                "horizontal_accuracy_m": 5.2,
                "vertical_accuracy_m": 4.6
            ]
        ]
        return dictionary
    }
}

struct HTTPClient {
    static func sendULU(ulu: ULU) {
        let url = Constants.APIBaseURL + "/ulu"
        let head_count = (ulu.toDictionary()["head_positions"] as? [Any])!.count
        let camera_count = (ulu.toDictionary()["camera_positions"] as? [Any])!.count
        print("head: \(head_count); camera: \(camera_count)")
        
        
//        Alamofire.request(url, method: .post, parameters: ulu.toDictionary(), encoding: JSONEncoding.default, headers: nil).response { response in
//            let json = JSON(response.data)
//            print(json)
//        }
    }
}
