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

struct Video: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .mpeg4Movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = URL.documentsDirectory.appending(path: "movie.mp4")
            
            if FileManager.default.fileExists(atPath: copy.path()) {
                try FileManager.default.removeItem(at: copy)
            }
            
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self.init(url: copy)
        }
    }
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

struct LocalMediaRepresentable: Identifiable, Equatable {
    let id = UUID().uuidString
    let imageMedia: LocalImageMedia?
    let videoMedia: LocalVideoMedia?
    var displayImage: Image? {
        if let imageMedia = imageMedia {
            return Image(uiImage: imageMedia.uiImage)
        } else if let videoMedia = videoMedia {
            return Image(uiImage: videoMedia.thumbnailImage)
        } else {
            return nil
        }
    }
    static func == (lhs: LocalMediaRepresentable, rhs: LocalMediaRepresentable) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(imageMedia: LocalImageMedia? = nil,
         videoMedia: LocalVideoMedia? = nil) {
        self.imageMedia = imageMedia
        self.videoMedia = videoMedia
    }
}

struct LocalImageMedia {
    let uiImage: UIImage
}

struct LocalVideoMedia {
    let thumbnailImage: UIImage
    let url: URL
    let videoDuration: VideoDuration?
}
