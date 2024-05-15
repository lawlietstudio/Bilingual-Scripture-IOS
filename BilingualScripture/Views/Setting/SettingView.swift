import SwiftUI
import AVFoundation

struct SectionData: Identifiable {
    let id = UUID()
    let title: String
    let voices: [AVSpeechSynthesisVoice]
    let speechLang: SpeechLang
    var isShow: Bool = false
}

struct SettingView: View {
    @AppStorage("fraVoiceIdentifier") private var selectedFraVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "fr-CA")!.identifier
    @AppStorage("engVoiceIdentifier") private var selectedEngVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "en-US")!.identifier
    @AppStorage("zhoVoiceIdentifier") private var selectedZhoVoiceIdentifier: String = AVSpeechSynthesisVoice(language: "zh-TW")!.identifier
    
    @AppStorage("useDarkMode") private var useDarkMode = false
    
    @State private var sections: [SectionData] = [
        SectionData(title: "Française", voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix("fr") }, speechLang: .fr),
        SectionData(title: "English", voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix("en") }, speechLang: .en),
        SectionData(title: "Chinese", voices: AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix("zh") }, speechLang: .zh)
    ]
    
    @State private var isEditing = false


    var body: some View {
        NavigationStack {
            List {
                ForEach($sections) { $section in
                    Section(header: Text(section.title)) {
//                    VStack(alignment: .leading) {
                        Toggle("Show", isOn: $section.isShow)
//                            .moveDisabled(true)
                        
                        Picker("Voice", selection: selectionBinding(for: section.speechLang)) {
                            ForEach(section.voices.map { $0.identifier }, id: \.self) { identifier in
                                let voice = AVSpeechSynthesisVoice(identifier: identifier)!
                                Text("\(voice.name) (\(voice.language))")
                                    .tag(identifier)
                            }
                        }
//                        .moveDisabled(true)
                        .pickerStyle(.navigationLink)
                    }
                    .onDrag {
                        NSItemProvider(object: section.id.uuidString as NSString)
                    }
                    .onDrop(of: [UTType.text], delegate: SectionDropDelegate(item: section, sections: $sections))
                }
//                .onMove(perform: moveSection)
            }
            .navigationTitle("Setting")
            .navigationBarItems(trailing: EditButton())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Image(systemName: isEditing ? "checkmark.circle.fill" : "arrow.up.arrow.down.circle")
                            .imageScale(.large)
                    }
                }
            }
            .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
            .listStyle(.plain)
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
    
    private func moveSection(from source: IndexSet, to destination: Int) {
        print("Moving section from \(source) to \(destination)")
        sections.move(fromOffsets: source, toOffset: destination)
        print("New sections order: \(sections.map { $0.title })")
    }

}

struct SectionDropDelegate: DropDelegate {
    let item: SectionData
    @Binding var sections: [SectionData]

    func dropEntered(info: DropInfo) {
        guard let sourceIndex = sections.firstIndex(where: { $0.id == UUID(uuidString: info.itemProviders(for: [UTType.text]).first?.suggestedName ?? "") }),
              let destinationIndex = sections.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        if sourceIndex != destinationIndex {
            withAnimation {
                let sourceItem = sections[sourceIndex]
                sections.remove(at: sourceIndex)
                sections.insert(sourceItem, at: destinationIndex)
            }
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        return true
    }
}
