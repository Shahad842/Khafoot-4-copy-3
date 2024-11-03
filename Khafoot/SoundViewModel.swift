//
//  SoundViewModel.swift
//  khafootTest1
//
//  Created by Shahad Alhothali on 28/04/1446 AH.
//

import SwiftUI
import AVFoundation
import Combine

// SoundViewModel
class SoundViewModel: ObservableObject {
    @Published var currentSound: SoundModel?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 0.0
    @Published var volume: Float = 0.5 {
        didSet {
            player?.volume = volume
        }
    }

    var player: AVAudioPlayer?
    private var timer: AnyCancellable?

    // Categories of sounds organized by type
    @Published var categories: [String: [SoundModel]] = [
        "Rain": [
            SoundModel(title: "Forest Rain", duration: 180, date: "2024-10-28", soundImage: "ForestRain", fileName: "ForestRain", category: "Rain"),
            SoundModel(title: "Street Rain", duration: 240, date: "2024-10-28", soundImage: "StreetRain", fileName: "StreetRain", category: "Rain"),
            SoundModel(title: "Thunder Rain", duration: 300, date: "2024-10-28", soundImage: "ThunderRain", fileName: "ThunderRain", category: "Rain"),
        ],
        "Nature": [
            SoundModel(title: "Night", duration: 180, date: "2024-10-28", soundImage: "Night", fileName: "Night", category: "Nature"),
            SoundModel(title: "Forest", duration: 240, date: "2024-10-28", soundImage: "Forest", fileName: "Forest", category: "Nature"),
            SoundModel(title: "Fire", duration: 300, date: "2024-10-28", soundImage: "Fire", fileName: "Fire", category: "Nature"),
        ],
        "Water": [
            SoundModel(title: "Beach", duration: 180, date: "2024-10-28", soundImage: "Beach", fileName: "Beach", category: "Water"),
            SoundModel(title: "SeaWaves", duration: 240, date: "2024-10-28", soundImage: "SeaWaves", fileName: "SeaWaves", category: "Water"),
            SoundModel(title: "Waterfall", duration: 300, date: "2024-10-28", soundImage: "Waterfall", fileName: "Waterfall", category: "Water"),
        ]
    ]


    // Load the selected sound and prepare the audio player
    func loadSound(_ sound: SoundModel) {
        currentSound = sound
        guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: "mp3") else { return }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = volume
            totalTime = player?.duration ?? 0
            currentTime = 0 // Reset current time
            startTimer()
        } catch {
            print("Error loading audio: \(error)")
        }
    }

    // Toggle play/pause state
    func togglePlayPause() {
        guard let player = player else { return }

        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }

    // Seek to a specific time
    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }

    // Update volume
    func updateVolume(_ newVolume: Float) {
        volume = newVolume
    }

    // Seek forward 15 seconds
    func seekForward15Seconds() {
        let newTime = min(currentTime + 15, totalTime)
        seek(to: newTime)
    }

    // Seek backward 15 seconds
    func seekBackward15Seconds() {
        let newTime = max(currentTime - 15, 0)
        seek(to: newTime)
    }

    // Start a timer to update current time
    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let player = self.player else { return }
                self.currentTime = player.currentTime
                
                // Stop playback if the end is reached
                if player.currentTime >= self.totalTime {
                    self.stopAudio() // Stop when reaching the end
                }
            }
    }

    // Stop audio playback and reset state
    func stopAudio() {
        player?.stop()  // Stop audio playback
        isPlaying = false // Update playing state
        currentTime = 0.0 // Reset current time
    }

    // Format duration for display
    func formatDuration(time: TimeInterval) -> String {
         let minutes = Int(time) / 60
         let seconds = Int(time) % 60
         return String(format: "%d:%02d", minutes, seconds)
     }

    // Create a shareable string for the current sound
    func shareCurrentSound() -> String {
        guard let sound = currentSound else { return "No sound to share." }
        return "Check out this sound: \(sound.title) - Listen here: [Link to Sound]" // Replace with actual link if available
    }
}