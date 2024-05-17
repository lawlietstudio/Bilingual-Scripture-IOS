import SwiftUI
import AVFoundation

struct SectionData: Identifiable {
    let id = UUID()
    let voices: [AVSpeechSynthesisVoice]
    let speechLang: SpeechLang
    var isShow: Bool = false
    
    init(voices: [AVSpeechSynthesisVoice], speechLang: SpeechLang) {
        self.voices = voices
        self.speechLang = speechLang
        let languageVisibilities = UserDefaults.standard.load()
        self.isShow = languageVisibilities.first { $0.speechLang == self.speechLang }?.isShow ?? false
    }
}

struct SettingView: View {
    @AppStorage("fraVoiceIdentifier") private var selectedFraVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "fr-CA")!.identifier
    @AppStorage("engVoiceIdentifier") private var selectedEngVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "en-US")!.identifier
    @AppStorage("zhoVoiceIdentifier") private var selectedZhoVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "zh-TW")!.identifier
    
    @AppStorage("useDarkMode") private var useDarkMode = false
    
    @State private var sections: [SectionData] = [
        SectionData(voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.contains("fr") }, speechLang: .fr),
        SectionData(voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.contains("en") }, speechLang: .en),
        SectionData(voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.contains("zh") }, speechLang: .zh)
    ]
    
    @State private var isEditing = false
    
    @StateObject private var itemStore = ItemStore()

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Display Order") {
                    LanguageOrderingView()
                }
                
                ForEach($sections) { $section in
                    Section(header: Text(section.speechLang.rawValue)) {
                        Toggle("Show/Hide", isOn: $section.isShow)
                            .toggleStyle(CheckmarkToggleStyle())
                            .onChange(of: section.isShow) { _, newValue in
                                if let index = itemStore.languageVisibilities.firstIndex(where: { $0.speechLang == section.speechLang }) {
                                    itemStore.languageVisibilities[index].isShow = newValue
                                    itemStore.saveItems()
                                }
                            }
                        
                        Picker("Voice", selection: selectionBinding(for: section.speechLang)) {
                            ForEach(section.voices.map { $0.identifier }, id: \.self) { identifier in
                                let voice = AVSpeechSynthesisVoice(identifier: identifier)!
                                Text("\(voice.name) (\(voice.language))")
                                    .tag(identifier)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                }
            }
            .navigationTitle("Setting")
        }
    }
    
    private func selectionBinding(for speechLang: SpeechLang) -> Binding<String> {
        switch speechLang {
        case .fr:
            return $selectedFraVoiceIdentifier
        case .en:
            return $selectedEngVoiceIdentifier
        case .zh:
            return $selectedZhoVoiceIdentifier
        }
    }
}
