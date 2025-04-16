//
//  SpeechViewModel.swift
//  BilingualScripture
//
//  Created by mark on 2025-04-15.
//

import SwiftUI
import AVFoundation

enum SpeechLang: String, Codable {
    case fr = "Française"
    case en = "English"
    case zh = "中文"
    case jp = "日本語"
    case kr = "한국어"
}

struct SpeakVersesPackage {
    var currentSpeechLang: SpeechLang
    var currentParagraphIndex: Int = -99
    var verses: [String]
}

@MainActor
class SpeechViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    let synthesizer = AVSpeechSynthesizer()
    
    @Published var currentSpeakingText: String?
    
    override init() {
        super.init()
        
        synthesizer.delegate = self
    }

    @Published var speakVersesPackage: SpeakVersesPackage?
    private var forceStopping: Bool = false
    private var isReplacingWithNew: Bool = false

    private func createUtterance(text: String, speechLang: SpeechLang) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        switch speechLang {
        case .fr:
            if let voiceIdentifier = UserDefaults.standard.string(forKey: "fraVoiceIdentifier"),
               let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "fr-CA" && $0.name == "Samantha" }) {
                // fr-CA || fr-FR
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "fr-CA" }) { 
                // fr-CA || fr-FR
                utterance.voice = voice
            }
        case .en:
            if let voiceIdentifier = UserDefaults.standard.string(forKey: "engVoiceIdentifier"),
               let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "en-US" && $0.name == "Samantha" }) {
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "en-US"}) {
                utterance.voice = voice
            }
        case .zh:
            if let voiceIdentifier = UserDefaults.standard.string(forKey: "zhoVoiceIdentifier"),
               let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "zh-HK" && $0.name == "Sinji" }) {
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "zh-HK" }) {
                utterance.voice = voice
            }
        case .jp:
            if let voiceIdentifier = UserDefaults.standard.string(forKey: "jpnVoiceIdentifier"),
               let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "ja-JP"}) {
                utterance.voice = voice
            }
        case .kr:
            if let voiceIdentifier = UserDefaults.standard.string(forKey: "korVoiceIdentifier"),
               let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "ko-KR" }) {
                utterance.voice = voice
            }
        }
        
        return utterance
    }
    
    public func speakVerses(verses: [String], speechLang: SpeechLang) {
        guard !verses.isEmpty else { return }
        
        self.stopSpeaking(forceStopping: false)
        
        speakVersesPackage = SpeakVersesPackage(currentSpeechLang: speechLang, verses: verses)
        speakVersesPackage?.currentParagraphIndex = 0

        Task { @MainActor in
            speakCurrentParagraph()
        }
    }
    
    public func speak(text: String, speechLang: SpeechLang) {
        self.stopSpeaking()
        
        let utterance = createUtterance(text: text, speechLang: speechLang)

        synthesizer.speak(utterance)
        currentSpeakingText = text
    }
    
    public func stopSpeaking(forceStopping: Bool = true) {
        self.forceStopping = forceStopping
        self.isReplacingWithNew = currentSpeakingText != nil
        
        synthesizer.stopSpeaking(at: .word)
        
        resetAll()
    }
    
    // AVSpeechSynthesizerDelegate method
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            if let package = speakVersesPackage, !forceStopping {
                if package.currentParagraphIndex + 1 < package.verses.count {
                    speakVersesPackage?.currentParagraphIndex += 1
                    speakCurrentParagraph()
                } else {
                    resetAll()
                }
            } else if !isReplacingWithNew {
                resetAll()
            }
            
            self.isReplacingWithNew = false
        }
    }
    
    @MainActor
    private func speakCurrentParagraph() {
        guard let package = speakVersesPackage,
              package.currentParagraphIndex < package.verses.count else {
            resetAll()
            return
        }

        currentSpeakingText = package.verses[package.currentParagraphIndex]
        
        if let currentSpeakingText {
            let utterance = createUtterance(text: currentSpeakingText, speechLang: package.currentSpeechLang)
            synthesizer.speak(utterance)
        }
    }
    
    private func resetAll() {
        currentSpeakingText = nil
        speakVersesPackage = nil
    }
}
