//
//  MemoAudio.swift
//  VoiceMemo
//
//  Created by Muhammad Moaz on 12/27/16.
//  Copyright © 2016 Muhammad Moaz. All rights reserved.
//

import Foundation
import AVFoundation

class MemoSessionManager {
    static let sharedInstance = MemoSessionManager()
    
    let session: AVAudioSession
    
    var permissionGranted: Bool {
        return session.recordPermission() == .granted
    }
    
    private init() {
        session = AVAudioSession.sharedInstance()
    }
    
    private func configureSession() {
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
        } catch {
            print(error)
        }
    }
    
    public func requestPermission(completion: @escaping (Bool) -> Void) {
        session.requestRecordPermission { permissionAllowed in
            completion(permissionAllowed)
        }
    }
}

class MemoRecorder {
    static let sharedInstance = MemoRecorder()
    
    private static let settings: [String: Any] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 22050.0,
        AVEncoderBitDepthHintKey: 16,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    private static func outputURL() -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first!
        let audioPath = documentsDirectory.appending("memo.m4a")
        return URL(string: audioPath)!
    }
    
    private let recorder: AVAudioRecorder
    
    private init() {
        self.recorder = try! AVAudioRecorder(url: MemoRecorder.outputURL(), settings: MemoRecorder.settings)
        recorder.prepareToRecord()
    }
    
    func start() {
        recorder.record()
    }
    
    func stop() -> String {
        recorder.stop()
        return recorder.url.absoluteString
    }
}
