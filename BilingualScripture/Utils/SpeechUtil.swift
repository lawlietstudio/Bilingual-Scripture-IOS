import Foundation
import AVFoundation

enum SpeechLang: String, Codable {
    case fr = "Française"
    case en = "English"
    case zh = "中文"
    case jp = "日本語"
    case kr = "한국어"
}

protocol SpeechUtilDelegate: AnyObject {
    func didStartSpeaking()
    func didFinishSpeaking()
}

class SpeechUtil: NSObject, AVSpeechSynthesizerDelegate {
    static var share = SpeechUtil()
    
    let synthesizer = AVSpeechSynthesizer()
    weak var delegate: SpeechUtilDelegate?
    private var isInterrupted = false
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    public func stopSpeaking() {
        isInterrupted = true
        delegate?.didFinishSpeaking()
        delegate = nil
        synthesizer.stopSpeaking(at: .word)
    }
    
    public func speak(text: String, speechLang: SpeechLang, newDelegate: SpeechUtilDelegate) {
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

        synthesizer.speak(utterance)
        self.delegate = newDelegate
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        delegate?.didStartSpeaking()
        isInterrupted = false
    }
    
    // AVSpeechSynthesizerDelegate method
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if !isInterrupted {
            delegate?.didFinishSpeaking()
        }
    }
}
