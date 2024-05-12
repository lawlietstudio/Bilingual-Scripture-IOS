//
//  LanguageVisibilityView.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-28.
//

import SwiftUI

class ItemStore: ObservableObject {
    @Published var languageVisibilities: [LanguageVisibility] {
        didSet {
            saveItems()
        }
    }
    
    init() {
        self.languageVisibilities = UserDefaults.standard.load()
    }
    
    func saveItems() {
        UserDefaults.standard.save(languageVisibilities)
    }
}

struct LanguageVisibilityView: View {
    @StateObject private var itemStore = ItemStore()
    
    var body: some View {
        NavigationView {
            List {
                EditButton()
                ForEach($itemStore.languageVisibilities) { $item in
                    HStack {
                        Text(item.speechLang.rawValue)
                            .foregroundColor(item.isShow ? .black : .gray)
                        Spacer()
                        Toggle("Show", isOn: $item.isShow)
                            .labelsHidden()
                    }
                }
                .onMove(perform: move)
            }
            .navigationTitle("Languages")
//            .toolbar(.hidden)
//            .toolbar {
//                EditButton()
//            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        itemStore.languageVisibilities.move(fromOffsets: source, toOffset: destination)
    }
}
