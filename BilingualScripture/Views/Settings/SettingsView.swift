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

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @AppStorage("fraVoiceIdentifier") private var selectedFraVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "fr-CA")!.identifier
    @AppStorage("engVoiceIdentifier") private var selectedEngVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "en-US")!.identifier
    @AppStorage("zhoVoiceIdentifier") private var selectedZhoVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "zh-TW")!.identifier
    @AppStorage("jpnVoiceIdentifier") private var selectedJpnVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "ja-JP")!.identifier
    @AppStorage("korVoiceIdentifier") private var selectedKorVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "ko-KR")!.identifier
    
    @State private var sections: [SectionData] = [
        SectionData(voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.contains("fr") }, speechLang: .fr),
        SectionData(voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.contains("en") }, speechLang: .en),
        SectionData(voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.contains("zh") }, speechLang: .zh),
        SectionData(voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.contains("ja") }, speechLang: .jp),
        SectionData(voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.contains("ko") }, speechLang: .kr)
    ]
    
    @State private var isEditing = false
    
    @StateObject private var itemStore = ItemStore()

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Verses")) {
                    NavigationLink("Display Order") {
                        LanguageOrderingView()
                    }
                    
                    Toggle("Show Verses Bar", isOn: $settingsViewModel.isVersesBarVisible)
                        .toggleStyle(CheckmarkToggleStyle())
                }
                
                Section(header: Text("Highlight")) {
                    Toggle("Show", isOn: $settingsViewModel.isVerseHighlighted)
                        .toggleStyle(CheckmarkToggleStyle())
                    
                    ColorPicker("Color", selection: $settingsViewModel.verseHighlightedColor)
                }
                
                
                ForEach($sections) { $section in
                    Section(header: Text(section.speechLang.rawValue)) {
                        Toggle("Show", isOn: $section.isShow)
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
                
                Text(getAppVersion())
                    .frame(alignment: .center)
                    .font(.subheadline)
            }
            .safeAreaPadding(.bottom, 16)
            .navigationTitle(Tab.settings.title)
        }
    }
    
    func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return "Version \(version)"
    }
    
    private func selectionBinding(for speechLang: SpeechLang) -> Binding<String> {
        switch speechLang {
        case .fr:
            return $selectedFraVoiceIdentifier
        case .en:
            return $selectedEngVoiceIdentifier
        case .zh:
            return $selectedZhoVoiceIdentifier
        case .jp:
            return $selectedJpnVoiceIdentifier
        case .kr:
            return $selectedKorVoiceIdentifier
        }
    }
}
