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

class TaggedUtterance: AVSpeechUtterance {
    let id: UUID

    init(text: String, id: UUID) {
        self.id = id
        super.init(string: text)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@MainActor
class SpeechViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private var currentUtteranceID: UUID?
    private var synthesizer = AVSpeechSynthesizer()
    
    @Published var currentSpeakingText: String?
    @Published var speakVersesPackage: SpeakVersesPackage?
    @Published var isPaused: Bool = false
    
    override init() {
        super.init()
        
        synthesizer.delegate = self
    }

    private func createUtterance(text: String, speechLang: SpeechLang, id: UUID) -> AVSpeechUtterance {
        let utterance = TaggedUtterance(text: text, id: id)
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
        
        stopSpeaking()
        
        speakVersesPackage = SpeakVersesPackage(currentSpeechLang: speechLang, verses: verses)
        speakVersesPackage?.currentParagraphIndex = 0

        Task { @MainActor in
            speakCurrentVerse()
        }
    }
    
    public func speak(text: String, speechLang: SpeechLang) {
        stopSpeaking()
        
        let id = UUID()
        currentUtteranceID = id
        let utterance = createUtterance(text: text, speechLang: speechLang, id: id)

        synthesizer.speak(utterance)
        currentSpeakingText = text
    }
    
    public func pauseSpeaking() {
        guard synthesizer.isSpeaking && !isPaused else { return }

        let didPause = synthesizer.pauseSpeaking(at: .word)
        if didPause {
            isPaused = true
        }
    }
    
    public func resumeSpeaking() {
        guard isPaused else { return }

        let didContinue = synthesizer.continueSpeaking()
        if didContinue {
            isPaused = false
        }
    }
    
    public func stopSpeaking() {      
        synthesizer.stopSpeaking(at: .word)
        resetAll()
    }
    
    // AVSpeechSynthesizerDelegate method
    /*
     Speech Flow Scenarios
     ----------------------

     (1) Normal: Speak a single line without interruption
         - Step 1: Call `stopSpeaking()` — does nothing meaningful in this context
         - Step 2: Call `speak()` — sets `currentText`, starts speaking
         - Step 3: `didFinish` is triggered — safely resets state (e.g., isSpeaking = false, currentText = nil)

     (2) Interrupted: Speak a new line while another is still speaking
         - Step 1: Call `stopSpeaking()` — this ends the current utterance
         - Step 2: Set `ignoreNextDidFinish = true` before calling `stopSpeaking()`
         - Step 3: Call `speak()` — sets new `currentText`, begins new utterance immediately
         - Step 4: `didFinish` of the **first** utterance fires — we skip resetting because it's outdated
         - Step 5: `didFinish` of the **second** utterance fires — now it's safe to reset state

     Note:
     - `ignoreNextDidFinish` is used to prevent `didFinish` from incorrectly resetting UI state
       (like `isSpeaking = false`) when a new utterance has already begun.
     - This avoids race conditions or flickering in the UI when speech is rapidly interrupted.
    */
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            guard let tagged = utterance as? TaggedUtterance,
                  tagged.id == currentUtteranceID else {
                return // It's an old/stale utterance, ignore
            }
            
            // Now safe to proceed
            if let package = speakVersesPackage {
                if package.currentParagraphIndex + 1 < package.verses.count {
                    speakVersesPackage?.currentParagraphIndex += 1
                    speakCurrentVerse()
                } else {
                    resetAll()
                }
            } else {
                resetAll()
            }
        }
    }
    
    @MainActor
    private func speakCurrentVerse() {
        guard let package = speakVersesPackage,
              package.currentParagraphIndex < package.verses.count else {
            resetAll()
            return
        }

        currentSpeakingText = package.verses[package.currentParagraphIndex]
        
        if let currentSpeakingText {
            let id = UUID()
            currentUtteranceID = id
            let utterance = createUtterance(text: currentSpeakingText, speechLang: package.currentSpeechLang, id: id)
            synthesizer.speak(utterance)
        }
    }
    
    private func resetAll() {
        resetSynthesizer()
        currentSpeakingText = nil
        speakVersesPackage = nil
        isPaused = false
    }
    
    private func resetSynthesizer() {
        synthesizer.delegate = nil
        let newSynth = AVSpeechSynthesizer()
        newSynth.delegate = self
        synthesizer = newSynth
    }
}
