//
//  ChapterSpeechUtil.swift
//  BilingualScripture
//
//  Created by mark on 2024-08-05.
//

import SwiftUI
import AVFoundation

class ChapterSpeechUtil: SingleSpeechUtil {
    static let shared: ChapterSpeechUtil = {
        let instance = ChapterSpeechUtil()
        return instance
    }()
    
    var remainingTexts: [String] = []
    var currentSpeechLang: SpeechLang = .en
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    public override func stopSpeaking(isStopOther: Bool = true) {
        if isStopOther {
            SingleSpeechUtil.share.stopSpeaking(isStopOther: false)
        }
        isInterrupted = true
        delegate?.didStopSpeaking()
        delegate = nil
        NotificationCenter.default.post(name: .currentVerseSpoke, object: "")
        remainingTexts.removeAll()
        synthesizer.stopSpeaking(at: .word)
    }
    
    public func speakVerses(verses: [String], speechLang: SpeechLang, newDelegate: SpeechUtilDelegate) {
        self.stopSpeaking()
        
        remainingTexts = verses
        currentSpeechLang = speechLang
        DispatchQueue.global(qos: .userInitiated).async {
            self.delegate = newDelegate
            NotificationCenter.default.post(name: .currentVerseSpoke, object: self.remainingTexts[0])
            let utterance = self.createUtterance(text: self.remainingTexts[0], speechLang: speechLang)
            DispatchQueue.main.async {
                self.synthesizer.speak(utterance)
            }
            self.remainingTexts = Array(self.remainingTexts.dropFirst())
        }
    }
    
    override func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if !isInterrupted {
            delegate?.didFinishSpeaking()
            if !remainingTexts.isEmpty {
                NotificationCenter.default.post(name: .currentVerseSpoke, object: remainingTexts[0])
                let utterance = createUtterance(text: remainingTexts[0], speechLang: currentSpeechLang)

                synthesizer.speak(utterance)
                remainingTexts = Array(remainingTexts.dropFirst())
            }
        }
    }
}
