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
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                Text(title)
                    .textCase(.uppercase)
                    .padding(.horizontal)
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                let visibleItems = vm.languageVisibilities.filter { $0.isShow }

                ForEach(visibleItems.indices, id: \.self) { index in
                    let visibility = visibleItems[index]
                    let font: Font = UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .subheadline

                    switch visibility.speechLang {
                    case .fr:
                        SpeakButton(text: multilingualText.fr, speechLang: .fr, font: font)
                    case .en:
                        SpeakButton(text: multilingualText.en, speechLang: .en, font: font)
                    case .zh:
                        SpeakButton(text: multilingualText.zh, speechLang: .zh, font: font)
                    case .jp:
                        SpeakButton(text: multilingualText.jp, speechLang: .jp, font: font)
                    case .kr:
                        SpeakButton(text: multilingualText.kr, speechLang: .kr, font: font)
                    }

                    // Add a divider if it's not the last item
                    if index < visibleItems.count - 1 {
                        Divider()
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 12))
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
