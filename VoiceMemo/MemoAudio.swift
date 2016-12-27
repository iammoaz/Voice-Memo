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
