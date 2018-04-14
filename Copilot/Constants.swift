//
//  Constants.swift
//  Copilot
//
//  Created by Adam Reis on 4/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

struct Constants {
    static let APIBaseURL = "https://copilotyc.herokuapp.com"
    static let userID = 1
    static let S3BucketName = "copilot-incident-images"
    static let S3BasePath = "https://s3-us-west-1.amazonaws.com/\(S3BucketName)/"
}
