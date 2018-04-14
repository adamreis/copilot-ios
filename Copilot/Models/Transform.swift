//
//  HeadPosition.swift
//  Copilot
//
//  Created by Adam Reis on 4/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Mapper
import ARKit

public struct Transform {
    public let transform: simd_float4x4
    public let date: Date
    public var timestamp_ms: Int {
        return Int(self.date.timeIntervalSince1970 * 1000)
    }
    
    public init(_ transform: simd_float4x4, date: Date = Date()) {
        self.transform = transform
        self.date = date
    }
}
