//
//  ULU.swift
//  Copilot
//
//  Created by Adam Reis on 4/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Mapper
import CoreLocation

public struct ULU {
    public let headPositions: [Transform]
    public let cameraPositions: [Transform]
    public let location: CLLocation
    
    public init(headPositions: [Transform], cameraPositions: [Transform]) {
        self.headPositions = headPositions
        self.cameraPositions = cameraPositions
        self.location = CLLocation(latitude: 0, longitude: 0)
    }
}
