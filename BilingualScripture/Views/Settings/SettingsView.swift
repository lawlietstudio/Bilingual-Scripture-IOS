import SwiftUI
import AVFoundation

struct SettingsView: View {
    @EnvironmentObject var languagesViewModel: LanguagesViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        NavigationStack {
            List {
                Section(
                    header:
                        HStack {
                            Text(languagesViewModel.localized("Languages"))
                            Spacer()
                            Button {
                                let temp = languagesViewModel.primaryLanguage
                                languagesViewModel.primaryLanguage = languagesViewModel.secondaryLanguage
                                languagesViewModel.secondaryLanguage = temp
                            } label: {
                                Image(systemName: "arrow.left.arrow.right")
                            }
                            .font(.caption)
                            .foregroundColor(.primary)
                        }
                ) {
                    Picker(languagesViewModel.localized("Primary Language"), selection: $languagesViewModel.primaryLanguage) {
                        ForEach(languagesViewModel.supportedLanguages, id: \.self) { lang in
                            Text(languagesViewModel.displayName(for: lang)).tag(lang)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    Picker(languagesViewModel.localized("Secondary Language"), selection: $languagesViewModel.secondaryLanguage) {
                        ForEach(languagesViewModel.supportedLanguages, id: \.self) { lang in
                            Text(languagesViewModel.displayName(for: lang)).tag(lang)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section(languagesViewModel.localized("settings.voices")) {
                    let primarySpeechLang = SpeechLang.speechLang(for: languagesViewModel.primaryLanguage)
                    let primarySpeechLangVoices = primarySpeechLang.getAvailableVoices(allVoices: languagesViewModel.allVoices)
                    
                    Picker(languagesViewModel.displayName(for: languagesViewModel.primaryLanguage), selection: SpeechLang.selectionBinding(for: primarySpeechLang, languageViewModel: Binding(get: { languagesViewModel }, set: { _ in }))) {
                        ForEach(primarySpeechLangVoices, id: \.self) { voice in
                            Text("\(voice.name) (\(voice.language))")
                                .tag(voice.identifier)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    let secondarySpeechLang = SpeechLang.speechLang(for: languagesViewModel.secondaryLanguage)
                    let secondarySpeechLangVoices = secondarySpeechLang.getAvailableVoices(allVoices: languagesViewModel.allVoices)
                    
                    Picker(languagesViewModel.displayName(for: languagesViewModel.secondaryLanguage), selection: SpeechLang.selectionBinding(for: secondarySpeechLang, languageViewModel: Binding(get: { languagesViewModel }, set: { _ in }))) {
                        ForEach(secondarySpeechLangVoices, id: \.self) { voice in
                            Text("\(voice.name) (\(voice.language))")
                                .tag(voice.identifier)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section(languagesViewModel.localized("settings.verses_bar")) {
                    Toggle(languagesViewModel.localized("settings.show"), isOn: $settingsViewModel.isVersesBarVisible)
                        .toggleStyle(CheckmarkToggleStyle())
                }
                
                Section(languagesViewModel.localized("settings.highlight_while_speaking")) {
                    Toggle(languagesViewModel.localized("settings.show"), isOn: $settingsViewModel.isVerseHighlighted)
                        .toggleStyle(CheckmarkToggleStyle())
                    
                    ColorPicker(languagesViewModel.localized("settings.color"), selection: $settingsViewModel.verseHighlightedColor)
                }


                Section(languagesViewModel.localized("settings.version")) {
                    Text(getAppVersion())
                        .frame(alignment: .center)
                        .font(.subheadline)
                }
            }
            .safeAreaPadding(.bottom, 16)
            .navigationTitle(Tab.settings.title(using: languagesViewModel))
        }
    }
    
    func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return "\(languagesViewModel.localized("settings.version")) \(version)"
    }
}
