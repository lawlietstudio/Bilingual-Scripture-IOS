import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
//    @State private var activeTab: Int = 0
    /// View Properties
    @State private var activeTab: Tab = .scripture
    /// Interface Style
    @State private var buttonRect: CGRect = .zero
    /// Current & Previous State Images
    @State private var currentImage: UIImage?
    @State private var previousImage: UIImage?
    /// So what I'm going to do is, whenever the dark mode is toggled, I will capture the current light mode screen view and store it inthe previos image variable, and I will capture the new state and store it in the current image variable. Once the snapshots have been take, I will use them as an overlay view to smoothly transition from one state to another via the maksing effect.
    @State private var maskAnimation: Bool = false
    
    @State private var tapShapePosition: CGPoint = .zero
    @Namespace private var tabItemAnimation
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                BooksView()
                    .setUpTab(.scripture)
                    .opacity(activeTab == .scripture ? 1 : 0)
                
                SettingsView()
                    .setUpTab(.settings)
                    .opacity(activeTab == .settings ? 1 : 0)
            }
            .animation(.spring, value: activeTab)
            .createImages(
                toggleDarkMode: settingsViewModel.isToggledDarkMode,
                currentImage: $currentImage,
                previousImage: $previousImage,
                activateDarkMode: $settingsViewModel.isActivatedDarkMode
            )
            
            CustomFloatingTabBar()
        }
        .accentColor(settingsViewModel.isActivatedDarkMode ? .white : .black)
        .overlay(content: {
            /// As you can see, the screen is captured in both light and dark modes, bt you can also see a little flickering while doing it. That's because the environment is changing from one state to another. To avoid that, I'm going to overlay a dummy view on the window, so we will not be able to see the flicker since the dummy view would be at the top.
            ///
            /// Note: We will be adding a dummy view to the since if we add it to the root view, it will also be captured. Once both snapshots have been take, we can remove the dummy view.
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                if let previousImage, let currentImage {
                    ZStack {
                        Image(uiImage: previousImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                        
                        Image(uiImage: currentImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                            .mask(alignment: .topLeading) {
                                Circle()
                                //                                    .fill(.red)
                                    .frame(width: buttonRect.width * (maskAnimation ? 80 : 1), height: buttonRect.height * (maskAnimation ? 80 : 1), alignment: .bottomLeading)
                                    .frame(width: buttonRect.width, height: buttonRect.height)
                                /// if your button is on the leading side, then change this to bottomTrailing
                                    .offset(x: buttonRect.minX, y: buttonRect.minY)
                                    .ignoresSafeArea()
                                //                                    .hidden()
                            }
                    }
                    .task {
                        guard !maskAnimation else { return }
                        withAnimation(.easeInOut(duration: 0.9), completionCriteria: .logicallyComplete) {
                            maskAnimation = true
                        } completion: {
                            /// Removing all snapshots
                            self.currentImage = nil
                            self.previousImage = nil
                            maskAnimation = false
                        }
                        
                    }
                }
            })
            /// Reverse Masking
            .mask({
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .frame(width: buttonRect.width, height: buttonRect.height)
                            .offset(x: buttonRect.minX, y: buttonRect.minY)
                            .blendMode(.destinationOut)
                    }
            })
            .ignoresSafeArea()
        })
        .overlay(alignment: .topTrailing) {
            if activeTab == .settings {
                Button {
                    settingsViewModel.isToggledDarkMode.toggle()
                } label: {
                    Image(systemName: settingsViewModel.isToggledDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.title2)
                        .foregroundStyle(Color.primary)
                        .symbolEffect(.bounce, value: settingsViewModel.isToggledDarkMode)
                        .frame(width: 40, height: 40)
                }
                .globalRect { rect in
                    buttonRect = rect
                }
                .padding(.top, -3.5)
                .padding(.trailing, 10.5)
                .disabled(currentImage != nil || previousImage != nil || maskAnimation)
            }
            // As you can see, every thing is fine, but we were able to notice a slightly dimmed previous button state icon. This is happening because the screenshot includes the previous button icon. To solve this, simply apply reverse making to the button area. As we already know the button position. it's easy to add the reverse mask to that position.
        }
        .preferredColorScheme(settingsViewModel.isActivatedDarkMode ? .dark : .light)
    }
       
    /// Custom Tab Bar
    /// With More Easy Customization
    @ViewBuilder
    func CustomFloatingTabBar() -> some View {
        /// Moving all the Remaining Tab Item's to Bottom
        HStack(alignment: .bottom, spacing: 0)
        {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabItem(tab: $0,
                        animation: tabItemAnimation,
                        activeTab: $activeTab,
                        positon: $tapShapePosition
                )
            }
        }

        .padding(.horizontal, 15)
        .padding(.top, -15)
        .background(content: {
            TabShape(midpoint: tapShapePosition.x)
                .fill(Color.background)
                .ignoresSafeArea()
                /// Adding Blur + Shadow
                /// For Shape Smoothening
                .shadow(color: .accentColor.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
        })
        /// Adding Animation
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
        
}

/// Tab Bar Item
struct TabItem: View {
    @EnvironmentObject var speechViewModel: SpeechViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var tab: Tab
    var animation: Namespace.ID
    @Binding var activeTab: Tab
    @Binding var positon: CGPoint
    
    /// Each Tab Item Position on the Screen
    @State private var tabPosition: CGPoint = .zero
    var body: some View {
        VStack(spacing: 0)
        {
            Image(systemName: tab.rawValue)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .background : .gray)
                /// increasing Size for the Active Tab
                .frame(width:activeTab == tab ? 50 : 35, height: activeTab == tab ? 50 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(Color.accentColor.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            
            Text(tab.title)
                .font(.caption)
                .foregroundColor(activeTab == tab ? .accentColor : .gray)
        }
        .frame(maxWidth:.infinity)
        .contentShape(Rectangle())
        .viewPosition(completion: { rect in
            tabPosition.x = rect.midX
            
            /// Update Active Tab Position
            if activeTab == tab {
                positon.x = rect.midX
            }
        })
        .onTapGesture {
            speechViewModel.stopSpeaking()
            
            activeTab = tab
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                positon.x = tabPosition.x
            }
        }
        .onLongPressGesture(minimumDuration: 5) {
            withAnimation {
                settingsViewModel.isLdsBooksVisible.toggle()
            }
        }
    }
}

#Preview {
    CustomTabView()
}
