//
//  Memo.swift
//  VoiceMemo
//
//  Created by Muhammad Moaz on 12/27/16.
//  Copyright © 2016 Muhammad Moaz. All rights reserved.
//

import Foundation
import CloudKit

struct Memo {
    static let entityName = "\(Memo.self)"
    
    let id: CKRecordID?
    let title: String
    let fileURLString: String
}

extension Memo {
    var fileURL: URL {
        return URL(fileURLWithPath: fileURLString)
    }
}
