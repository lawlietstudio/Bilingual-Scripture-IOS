import SwiftUI
import AVFoundation

struct SettingView: View {
//    @State private var selectedEngVoiceIdentifier: String = UserDefaults.standard.string(forKey: "engVoiceIdentifier") ?? AVSpeechSynthesisVoice(language: "en-US")!.identifier
//    @State private var selectedZhoVoiceIdentifier: String = UserDefaults.standard.string(forKey: "zhoVoiceIdentifier") ?? AVSpeechSynthesisVoice(language: "zh-TW")!.identifier
    
    @AppStorage("fraVoiceIdentifier") private var selectedFraVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "fr-CA")!.identifier
    @AppStorage("engVoiceIdentifier") private var selectedEngVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "en-US")!.identifier
    @AppStorage("zhoVoiceIdentifier") private var selectedZhoVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "zh-TW")!.identifier
    
    @AppStorage("useDarkMode") private var useDarkMode = false


    var body: some View {
        NavigationStack {
            NavigationLink {
                LanguageVisibilityView()
            } label: {
                Text("Language Visibility")
            }

            
            VStack {
                HStack {
                    VStack {
                        Text("Fra Voice:")
                        
                        Picker("Select a voice", selection: $selectedFraVoiceIdentifier) {
                            ForEach(AVSpeechSynthesisVoice.speechVoices().filter({ isFraVoice($0.language) }).map { $0.identifier }, id: \.self) { identifier in
                                let voice = AVSpeechSynthesisVoice(identifier: identifier)!
                                Text("\(voice.name)(\(voice.language))")
                                    .tag(identifier)
                            }
                        }
                        .pickerStyle(.wheel)
//                        .onChange(of: selectedEngVoiceIdentifier) { _, newIdentifier in
//                            UserDefaults.standard.set(newIdentifier, forKey: "engVoiceIdentifier")
//                        }
                    }
                }
                HStack {
                    VStack {
                        Text("Eng Voice:")
                        
                        Picker("Select a voice", selection: $selectedEngVoiceIdentifier) {
                            ForEach(AVSpeechSynthesisVoice.speechVoices().filter({ isEngVoice($0.language) }).map { $0.identifier }, id: \.self) { identifier in
                                let voice = AVSpeechSynthesisVoice(identifier: identifier)!
                                Text("\(voice.name)(\(voice.language))")
                                    .tag(identifier)
                            }
                        }
                        .pickerStyle(.wheel)
//                        .onChange(of: selectedEngVoiceIdentifier) { _, newIdentifier in
//                            UserDefaults.standard.set(newIdentifier, forKey: "engVoiceIdentifier")
//                        }
                    }
                    
                    VStack {
                        Text("Zho Voice:")
                        
                        Picker("Select a voice", selection: $selectedZhoVoiceIdentifier) {
                            ForEach(AVSpeechSynthesisVoice.speechVoices().filter({ isZhoVoice($0.language) }).map { $0.identifier }, id: \.self) { identifier in
                                let voice = AVSpeechSynthesisVoice(identifier: identifier)!
                                Text("\(voice.name)(\(voice.language))")
                                    .tag(identifier)
                            }
                        }
                        .pickerStyle(.wheel)
//                        .onChange(of: selectedZhoVoiceIdentifier) { _, newIdentifier in
//                            UserDefaults.standard.set(newIdentifier, forKey: "zhoVoiceIdentifier")
//                        }
                    }
                }
            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        useDarkMode.toggle()
//                    }) {
//                        Image(systemName: useDarkMode ? "sun.max.fill" : "moon.fill")
//                            .animation(.spring, value: useDarkMode)
//                    }
//                }
//            }
        }
    }
    
    private func isFraVoice(_ language: String) -> Bool {
        return language.contains("fr")
    }
    
    private func isEngVoice(_ language: String) -> Bool {
        return language.contains("en")
//            || language.contains("ja")
//            || language.contains("ko")
//        return true
    }
    
    private func isZhoVoice(_ language: String) -> Bool {
        return language.contains("zh")
    }
}
