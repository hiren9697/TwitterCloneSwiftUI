//
//  ComposeTweetModel.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 06/06/23.
//

import SwiftUI
import PhotosUI

struct LocalImage: Identifiable {
    let id = UUID().uuidString
    let image: Image
    let uiImage: UIImage
}

struct VideoDuration {
    let totalSeconds: Float64
    let hour: Int
    let minute: Int
    let seconds: Int
    var displayText: String {
        let displayHours: String = String(format: "%02d", hour)
        let displayMinutes: String = String(format: "%02d", minute)
        let displaySeconds: String = String(format: "%02d", seconds)
        if hour > 0 {
            return "\(displayHours):\(displayMinutes):\(displaySeconds)"
        } else {
            return "\(displayMinutes):\(displaySeconds)"
        }
    }
    
    init(totalSeconds: Float64) {
        self.totalSeconds = totalSeconds
        self.hour = Int(totalSeconds / 3600)
        self.minute = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
        self.seconds = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
    }
}

struct LocalMedia: Identifiable {
    let id = UUID().uuidString
    let displayImage: Image
    let type: PHAssetMediaType
    let uiImage: UIImage?
    let videoURL: URL?
    let videoDuration: VideoDuration?
    
    init(displayImage: Image,
         type: PHAssetMediaType,
         uiImage: UIImage? = nil,
         videoURL: URL? = nil,
         videoDurationTotalSeconds: Float64?) {
        self.displayImage = displayImage
        self.type = type
        self.uiImage = uiImage
        self.videoURL = videoURL
        if let videoDurationTotalSeconds = videoDurationTotalSeconds {
            self.videoDuration = VideoDuration(totalSeconds: videoDurationTotalSeconds)
        } else {
            self.videoDuration = nil
        }
    }
}
