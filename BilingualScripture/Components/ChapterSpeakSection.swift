//
//  ChapterSpeakSection.swift
//  BilingualScripture
//
//  Created by Mark Ho on 2024-05-17.
//

import SwiftUI
import Combine

struct ChapterSpeakSection: View {
    var title: String?
    var multilingualText: MultilingualText
    @StateObject var vm = CommSpeakSectionViewModel()

    var body: some View {
        Section(title ?? "") {
            ForEach(vm.languageVisibilities) { visibility in
                if visibility.isShow {
                    switch visibility.speechLang {
                    case .fr:
                        SpeakButton(text: multilingualText.fr, speechLang: .fr, font: UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .subheadline)
                    case .en:
                        SpeakButton(text: multilingualText.en, speechLang: .en, font: UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .subheadline)
                    case .zh:
                        SpeakButton(text: multilingualText.zh, speechLang: .zh, font: UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .subheadline)
                    case .jp:
                        SpeakButton(text: multilingualText.jp, speechLang: .jp, font: UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .subheadline)
                    case .kr:
                        SpeakButton(text: multilingualText.kr, speechLang: .kr, font: UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .subheadline)
                    }
                }
            }
        }
    }
}

class CommSpeakSectionViewModel: ObservableObject {
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
