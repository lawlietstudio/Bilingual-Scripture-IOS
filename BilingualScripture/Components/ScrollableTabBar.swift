//
//  ScrollableTabBar.swift
//  BilingualScripture
//
//  Created by mark on 2024-04-29.
//

import SwiftUI

struct ScrollableTabBar<content: View>: View {
    @EnvironmentObject var languagesViewModel: LanguagesViewModel
    /// View Properties
    @State private var activeTab: TabModel.Tab
    @State private var tabBarScrollState: TabModel.Tab?
    @State private var mainViewScrollState: TabModel.Tab?
    @State private var progress : CGFloat = .zero
    var tabContents: [content]
    @State var tabs: [TabModel]
    
    init(tabContents: [content], tabs: [TabModel]) {
        self.tabContents = tabContents
        self._tabs = State(initialValue: tabs)
        if let firstTab = tabs.first?.id {
            activeTab = firstTab
        } else {
            activeTab = .ot
        }
    }
    
    var body: some View {
        CustomTabBar()
        
        /// Main VIew
        ResponsiveView { props in
            let size = props.size
            
            // With ios 17, we can now create paging views more easily then ever before it. It is important to note that each tab view within the scrollview must be full screen width, else, paging will not work properly
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    /// YOUR INDIVIDUAL TAB VIEWS
                    ForEach(tabs) { tab in
                        tabContents[tabs.firstIndex { $0.id == tab.id }!]
                            .frame(width: size.width, height: size.height)
                            .contentShape(.rect)
                    }
                }
                .scrollTargetLayout()
                .rect { rect in
                    progress = -rect.minX / size.width
                }
            }
            // It is important to notice that the scroll position mush match the precise data type of the id supplied in the ForEach loop, In this example, the id is a Tab enum, this the mainViewScrollState property is also a Tab data type
            .scrollPosition(id: $mainViewScrollState)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .onChange(of: mainViewScrollState) { oldValue, newValue in
                if let newValue {
                    withAnimation(.snappy) {
                        tabBarScrollState = newValue
                        activeTab = newValue
                    }
                }
            }
            .onChange(of: props.size, { oldValue, newValue in
                mainViewScrollState = nil
                tabBarScrollState = nil
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.snappy(duration: 0.65)) {
                        mainViewScrollState = activeTab
                        tabBarScrollState = activeTab
                    }
                }
            })
        }
    }
    
    /// Dynamic Scrollable Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach($tabs) { $tab in
                    Button {
                        withAnimation(.snappy) {
                            activeTab = tab.id
                            tabBarScrollState = tab.id
                            mainViewScrollState = tab.id
                        }
                    } label: {
                        Text(tab.id.title(using: languagesViewModel))
                            .padding(.vertical, 12)
                            .foregroundColor(activeTab == tab.id ? Color.primary : .gray)
                            .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .rect { rect in
                        tab.size = rect.size
                        tab.minX = rect.minX
                    }
                }
            }
        }
        // I simply set the get property beacuse I just needed to update teh scroll position
        .scrollPosition(id: .init(get: {
            return tabBarScrollState
        }, set: { _ in
            
        }))
        .overlay(alignment: .bottom, content: {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                
                let inputRange = tabs.indices.compactMap { return CGFloat($0) }
                let outputRange = tabs.compactMap { return $0.size.width }
                let outputPositionRange = tabs.compactMap { return $0.minX }
                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
                let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: indicatorWidth, height: 1.5)
                    .offset(x: indicatorPosition)
            }
        })
        .safeAreaPadding(.horizontal, 15)
        .scrollIndicators(.hidden)
    }
}
