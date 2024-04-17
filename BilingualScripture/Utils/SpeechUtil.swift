import Foundation
import AVFoundation

enum SpeechLang {
    case en
    case zh
}

class SpeechUtil {
    static var share = SpeechUtil()
    
    let synthesizer = AVSpeechSynthesizer()
    
    public func stopSpeaking() {
        synthesizer.stopSpeaking(at: .word)
    }
    
    public func speak(text: String, speechLang: SpeechLang) {
        self.stopSpeaking()
        
        let utterance = AVSpeechUtterance(string: text)
        switch speechLang {
        case .en:
            if let voiceIdentifier = UserDefaults.standard.string(forKey: "engVoiceIdentifier"),
               let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "en-US" && $0.name == "Samantha" }) {
                utterance.voice = voice
            }
        case .zh:
            if let voiceIdentifier = UserDefaults.standard.string(forKey: "zhoVoiceIdentifier"),
               let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "zh-HK" && $0.name == "Sinji" }) {
                utterance.voice = voice
            }
        }
        synthesizer.speak(utterance)
    }
    
    //    private func speak(text: String, speechLang: SpeechLang) {
    //        let utterance = AVSpeechUtterance(string: text)
    //        switch speechLang {
    //        case .en:
    //            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    //        case .zh:
    //            utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
    //        }
    //        synthesizer.speak(utterance)
    //    }
}
