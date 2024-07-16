//
//  SpeakSection.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-28.
//

import SwiftUI
import Combine

struct SpeakSection: View {
    var title: String?
    var themeMultilingualText: MultilingualText
    var introMultilingualText: MultilingualText
    @StateObject var vm = CommSpeakSectionViewModel()
    
    var body: some View {
        if let title {
            Text(title)
                .foregroundStyle(.gray)
                .font(.caption2)
                .textCase(.uppercase)
        }
        
        ForEach(vm.languageVisibilities) { visibility in
            if visibility.isShow {
                switch visibility.speechLang {
                case .fr:
                    SpeakButton(text: showThemeOrIntro(theme: themeMultilingualText.fr, intro: introMultilingualText.fr), speechLang: .fr)
                case .en:
                    SpeakButton(text: showThemeOrIntro(theme: themeMultilingualText.en, intro: introMultilingualText.en), speechLang: .en)
                case .zh:
                    SpeakButton(text: showThemeOrIntro(theme: themeMultilingualText.zh, intro: introMultilingualText.zh), speechLang: .zh)
                case .jp:
                    SpeakButton(text: showThemeOrIntro(theme: themeMultilingualText.jp, intro: introMultilingualText.jp), speechLang: .jp)
                case .kr:
                    SpeakButton(text: showThemeOrIntro(theme: themeMultilingualText.kr, intro: introMultilingualText.kr), speechLang: .kr)
                }
            }
        }
    }
    
    func showThemeOrIntro(theme: String, intro: String) -> String {
        return theme.count > intro.count ? theme : intro
    }
}

class SpeakSectionViewModel: ObservableObject {
    @Published var languageVisibilities: [LanguageVisibility] = UserDefaults.standard.load()
    private var cancellables: AnyCancellable?
    
    init() {
        bindUserDefaults()
    }
    
    private func bindUserDefaults() {
        cancellables = NotificationCenter.default.publisher(for: .itemsDataDidChange)
            .receive(on: RunLoop.main)
            .sink { _ in
                self.languageVisibilities = UserDefaults.standard.load()
            }
    }
}
