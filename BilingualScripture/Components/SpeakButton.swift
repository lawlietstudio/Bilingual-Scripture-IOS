//
//  SpeakButton.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-02.
//

import SwiftUI
import Combine

struct SpeakButton: View {
    let text: String
    let speechLang: SpeechLang
    var font: Font = .subheadline
    @StateObject var speakButtonViewModel = SpeakButtonViewModel()
    
    var body: some View {
        Button(action: {
            speakButtonViewModel.isReading = true
            SpeechUtil.share.speak(text: text, speechLang: speechLang, newDelegate: self.speakButtonViewModel)
        }) {
            VStack(alignment: .leading) {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .font(font)
                    .italic(speakButtonViewModel.isHighlighted && speakButtonViewModel.isReading)
                    .underline(speakButtonViewModel.isHighlighted && speakButtonViewModel.isReading)
                    .foregroundColor((speakButtonViewModel.isHighlighted && speakButtonViewModel.isReading) ? speakButtonViewModel.highlightColor : .accentColor)
            }
//            .animation(.spring, value: speakButtonViewModel.isReading)
        }
//        .onAppear {
//            if let highlightColorHex = UserDefaults.standard.string(forKey: "highlightColor") {
//                speakButtonViewModel.highlightColor = Color(hex: highlightColorHex)
//                print("Another view appeared with color: \(highlightColorHex) \(speakButtonViewModel.highlightColor)")
//            }
//        }
        .buttonStyle(.plain)
    }
}

class SpeakButtonViewModel: ObservableObject, SpeechUtilDelegate {
    @Published var isReading = false
    @Published var highlightColor: Color = .blue
    @Published var isHighlighted: Bool = false
    private var cancellables: AnyCancellable?
    
    init() {
        bindUserDefaults()
        setHighlightColor()
    }
    
    private func setHighlightColor() {
        if let highlightColorHex = UserDefaults.standard.string(forKey: "highlightColor") {
            self.highlightColor = Color(hex: highlightColorHex)
        }
        
//        if let isHighlighted = UserDefaults.standard.bool(forKey: "isHighlighted") {
            self.isHighlighted = UserDefaults.standard.bool(forKey: "isHighlighted")
//        }
    }
    
    private func bindUserDefaults() {
        cancellables = NotificationCenter.default.publisher(for: .highlightColorDidChange)
            .receive(on: RunLoop.main)
            .sink { _ in
                self.setHighlightColor()
            }
    }
    
    func didStartSpeaking() {
        self.isReading = true
    }
    
    func didFinishSpeaking() {
        self.isReading = false
        SpeechUtil.share.delegate = nil
    }
}
