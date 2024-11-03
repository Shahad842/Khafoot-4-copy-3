//
//  SoundModel.swift
//  khafootTest1
//
//  Created by Shahad Alhothali on 28/04/1446 AH.
//

import SwiftUI
import AVFoundation
import Combine

// Sound Model SoundModel
struct SoundModel: Identifiable {
    var id = UUID()
    var title: String
    var duration: TimeInterval
    var date: String
    var soundImage: String
    var fileName: String
    var category: String // New category property
}

struct Track {
    let title: String
    let imageName: String
    let fileName: String
}
