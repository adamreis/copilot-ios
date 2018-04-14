//
//  ULUResponse.swift
//  Copilot
//
//  Created by Adam Reis on 4/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Mapper

public struct FaceScore {
    public let score: Double
    public let date: Date
    public var timestamp_ms: Int {
        return Int(self.date.timeIntervalSince1970 * 1000)
    }
}

extension FaceScore: Mappable {
    public init(map: Mapper) throws {
        let time_ms: Int = try! map.from("time_ms")
        self.date = Date(timeIntervalSince1970: Double(time_ms) / 1000)
        self.score = try! map.from("score")
    }
}

public struct ULUResponse {
    public let scores: [FaceScore]
}

extension ULUResponse: Mappable {
    public init(map: Mapper) throws {
        self.scores = try map.from("scores")
    }
}


