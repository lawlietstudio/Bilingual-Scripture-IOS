//
//  LanguageOrderingView.swift
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

struct LanguageOrderingView: View {
    @StateObject private var itemStore = ItemStore()
    @State private var editMode: EditMode = .active
    
    var body: some View {
        List {
            ForEach($itemStore.languageVisibilities) { $item in
                HStack {
                    Text(item.speechLang.rawValue)
                }
            }
            .onMove(perform: move)
        }
        .environment(\.editMode, $editMode)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Display Order")
                    .bold()
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        itemStore.languageVisibilities.move(fromOffsets: source, toOffset: destination)
    }
}
