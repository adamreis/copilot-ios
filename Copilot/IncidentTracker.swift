//
//  IncidentTracker.swift
//  Copilot
//
//  Created by Adam Reis on 4/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

private let kMaxScoreAgeMs = 4000 // 40s
private let kIndividualScoreThreshold = 0.5
private let kIncidentTriggerThreshold = 0.6
private let kMinimumScoreCount = 20

class IncidentTracker {
    static let sharedInstance = IncidentTracker()
    
    private var scores: [FaceScore] = []
    private var currentIncidentStart: Date?
    
    private init() {}
    
    public func addScores(_ newScores: [FaceScore]) {
        let now = newScores.last?.timestamp_ms ?? Int(Date().timeIntervalSince1970 * 1000)
        let sizeBefore = self.scores.count
        print("new scores: \(newScores.map { $0.score })")
        self.scores = (self.scores + newScores).filter { $0.timestamp_ms > now - kMaxScoreAgeMs }.sorted { $0.date < $1.date }
        let sizeAfter = self.scores.count
        print("before: \(sizeBefore), after: \(sizeAfter)")
        self.evaluateIncidents()
    }
    
    private func evaluateIncidents() {
        let above_threshold = self.scores.filter { $0.score < kIndividualScoreThreshold }
        let offenseRatio: Double = Double(above_threshold.count) / Double(self.scores.count)
        print("offenseRatio: \(offenseRatio)")
        
        if let incidentStart = self.currentIncidentStart, (self.scores.count < kMinimumScoreCount || offenseRatio < kIncidentTriggerThreshold) {
            let incidentEnd: Date = above_threshold.first?.date ?? Date()
            self.reportIncident(start: incidentStart, end: incidentEnd)
            self.currentIncidentStart = nil
            print("INCIDENT STOPPED")
        } else if self.currentIncidentStart == nil && self.scores.count >= kMinimumScoreCount && offenseRatio > kIncidentTriggerThreshold {
            self.currentIncidentStart = above_threshold.first!.date
            print("INCIDENT STARTED")
        }
    }
    
    private func reportIncident(start: Date, end: Date) {
        HeadPositionManager.sharedInstance.uploadImagesBetween(start: start, end: end)
    }
}
