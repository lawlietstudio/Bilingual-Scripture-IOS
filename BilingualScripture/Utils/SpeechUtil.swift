import Foundation
import AVFoundation

enum SpeechLang: String, Codable {
    case fr = "Française"
    case en = "English"
    case zh = "中文"
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
        case .fr:
            if let voiceIdentifier = UserDefaults.standard.string(forKey: "fraVoiceIdentifier"),
               let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
                utterance.voice = voice
            } else if let voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language == "fr-CA" && $0.name == "Samantha" }) { // fr-CA || fr-FR
                utterance.voice = voice
            }
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
}
