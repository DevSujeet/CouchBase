//
//  Constants.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/17/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation
import UIKit

//URL(string: "http://127.0.0.1:4984/ask")!

struct ZeroStateInfo {
    static let zeroStateAlert = "AlertZeroState"
    static let zeroStateTrack = "TrackZeroState"
    static let zeroStateAsk = "AskZeroState"
    
    static let ZeroStateAlertLabel = "When cuddle finds stuff that require your attention they  will show up here."
    static let ZeroStateTrackTitleLabel = "This is your dashboard."
    static let ZeroStateTrackLabel = "When you ask cuddle to track insights they show up here."
    static let ZeroStateAsKLabel = "how can I help you?"
    static let ZeroStateLabelColor = UIColor(hex6:0xA8A8A8)

}

struct Constants {
    //To keep track of version changes
    static let CBLVersionHistory:[String] = []
    //Current version of CBL view/indexes
    static let CBLVersion = "1"
    static let kSyncGatewayUrl = "http://172.18.40.23:4984/"///"http://127.0.0.1:4984/" //"http://52.191.193.71/"
    
    static let docIDDateFormat = "yyyy-mm-dd hh:mm:ss"
}
