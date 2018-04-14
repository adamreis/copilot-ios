//
//  IncidentTracker.swift
//  Copilot
//
//  Created by Adam Reis on 4/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import AVFoundation

private let kMaxScoreAgeMs = 3000 // 3s
private let kIndividualScoreThreshold = 0.5
private let kIncidentTriggerThreshold = 0.6
private let kMinimumScoreCount = 20

class IncidentTracker {
    static let sharedInstance = IncidentTracker()
    
    private var scores: [FaceScore] = []
    private var currentIncidentStart: Date?
    private var beepPlayer: AVAudioPlayer?
    private var bleepPlayer: AVAudioPlayer?
    
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
            self.playAlertSound()
        }
    }
    
    private func reportIncident(start: Date, end: Date) {
        HeadPositionManager.sharedInstance.uploadImagesBetween(start: start, end: end)
    }
    
    private func playAlertSound() {
        if self.currentIncidentStart == nil {
            return
        }

        guard let beepUrl = Bundle.main.url(forResource: "beep", withExtension: "mp3"),
            let bleepUrl = Bundle.main.url(forResource: "bleep", withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.beepPlayer = try AVAudioPlayer(contentsOf: beepUrl, fileTypeHint: AVFileType.mp3.rawValue)
            guard let beepPlayer = self.beepPlayer else { return }
            beepPlayer.prepareToPlay()
            
            self.bleepPlayer = try AVAudioPlayer(contentsOf: bleepUrl, fileTypeHint: AVFileType.mp3.rawValue)
            guard let bleepPlayer = self.bleepPlayer else { return }
            bleepPlayer.prepareToPlay()
            
            beepPlayer.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                bleepPlayer.play()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.playAlertSound()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}
