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
    
    @AppStorage("isHighlighted") private var isHighlightedStorage: Bool = true
    @State private var isHighlighted: Bool = true
    
    @AppStorage("highlightColor") private var highlightColorHex: String = "#0000FF" // Default to blue
    @State private var highlightColor: Color = .blue

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Display Order") {
                    LanguageOrderingView()
                }
                
                Section(header: Text("Highlight")) {
                    Toggle("Show/Hide", isOn: $isHighlighted)
                        .toggleStyle(CheckmarkToggleStyle())
                        .onChange(of: isHighlighted) { _, newValue in
                            isHighlightedStorage = newValue
                            NotificationCenter.default.post(name: .highlightColorDidChange, object: nil)
                        }
                    
                    ColorPicker("Color", selection: $highlightColor)
                        .onChange(of: highlightColor, { _, newValue in
                            highlightColorHex = newValue.hexString
                            NotificationCenter.default.post(name: .highlightColorDidChange, object: nil)
                            print(highlightColorHex)
                        })
                        .onAppear {
                            print("onAppear\(highlightColorHex)")
                            highlightColor = Color(hex: highlightColorHex)
                        }
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
                
                Text(getAppVersion())
                    .frame(alignment: .center)
                    .font(.subheadline)
            }
            .safeAreaPadding(.bottom, 16)
            .navigationTitle("Setting")
        }
    }
    
    func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "Version \(version) (Build \(build))"
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
