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
            SingleSpeechUtil.share.speak(text: text, speechLang: speechLang, newDelegate: self.speakButtonViewModel)
        }) {
            VStack(alignment: .leading) {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .font(font)
                    .italic(speakButtonViewModel.isHighlighted && checkIsReading())
                    .underline(speakButtonViewModel.isHighlighted && checkIsReading())
                    .foregroundColor((speakButtonViewModel.isHighlighted && checkIsReading()) ? speakButtonViewModel.highlightColor : .accentColor)
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
    
    func checkIsReading() -> Bool {
        return speakButtonViewModel.isReading || text == speakButtonViewModel.currentVerseSpoke
    }
}

class SpeakButtonViewModel: ObservableObject, SpeechUtilDelegate {
    @Published var isReading = false
    @Published var highlightColor: Color = .blue
    @Published var isHighlighted: Bool = false
    private var cancellables: AnyCancellable?
    @Published var currentVerseSpoke: String?
    private var currentVerseSpokeCancellables: AnyCancellable?
    
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
        
        
        currentVerseSpokeCancellables = NotificationCenter.default.publisher(for: .currentVerseSpoke)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { notification in
                if let text = notification.object as? String {
                    self.currentVerseSpoke = text
                }
            })
    }
    
    func didStartSpeaking() {
        self.isReading = true
    }
    
    func didFinishSpeaking() {
        self.isReading = false
        SingleSpeechUtil.share.delegate = nil
    }
}
