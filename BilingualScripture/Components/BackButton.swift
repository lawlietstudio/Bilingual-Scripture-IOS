//
//  BackButton.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-04.
//

import SwiftUI

struct BackButton: View {
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .fontWeight(.semibold)
                .font(.title)
            Text("Back")
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    BackButton()
}
