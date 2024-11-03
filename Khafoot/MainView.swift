//
//  MainView.swift
//  khafootTest1
//
//  Created by Shahad Alhothali on 28/04/1446 AH.
//
import SwiftUI
import AVFoundation
import Combine

// MainView
struct MainView: View {
    @StateObject var viewModel = SoundViewModel()
    @State private var selectedSound: SoundModel? // Keep track of the selected sound
    @State private var isPresentingSoundView = false // State to control the presentation of SoundView

    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    Text("Listen Now")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(width: 176, height: 100)
                        .foregroundColor(Color("AccentColor"))
                        .padding()
                    
                    Spacer()
                    NavigationLink(destination: SettingsView()) { // Updated to NavigationLink
                                              Image(systemName: "gearshape")
                                                  .font(.title)
                                                  .foregroundColor(Color("AccentColor"))
                                                  .padding()
                                          }
                }
                ScrollView {
                    ForEach(Array(viewModel.categories.keys), id: \.self) { category in
                        VStack(alignment: .leading) {
                            HStack  {
                                Text(category)
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .padding(.leading)
                                        
                                Spacer()
                                
                                NavigationLink(destination: RainView()) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("AccentColor"))
                                        .font(.subheadline)
                                        .padding(.trailing)
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: -20) {
                                    ForEach(viewModel.categories[category] ?? []) { sound in
                                        SoundCard(sound: sound)
                                            .onTapGesture {
                                                selectedSound = sound // Set the selected sound
                                                viewModel.loadSound(sound) // Load the sound
                                                isPresentingSoundView = true // Trigger the full-screen modal
                                            }
                                    }
                                }
                                .padding(.leading, 1)
                            }
                        }
                    }
                }
                // Present the SoundView as a full-screen cover
                .fullScreenCover(isPresented: $isPresentingSoundView) {
                    SoundView(viewModel: viewModel, expandSheet: $isPresentingSoundView)
                        .onAppear {
                            // Additional setup if needed when the SoundView appears
                        }
                        .onDisappear {
                            // Stop audio when dismissing SoundView
                            viewModel.stopAudio()
                        }
                }
            }
        }
    }
}
