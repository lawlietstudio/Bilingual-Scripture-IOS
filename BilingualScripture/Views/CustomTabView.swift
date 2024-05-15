import SwiftUI

struct CustomTabView: View {
//    @State private var activeTab: Int = 0
    /// View Properties
    @State private var activeTab: Tab = .scripture
    /// All Tab's
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab in
        return .init(tab: tab)
    }
    /// Sample Toggle States
    @State private var toggles: [Bool] = Array(repeating: false, count: 10)
    /// Interface Style
    @AppStorage("toggleDarkMode") private var toggleDarkMode: Bool = false
    @AppStorage("activateDarkMode") private var activateDarkMode: Bool = false
    @State private var buttonRect: CGRect = .zero
    /// Current & Previous State Images
    @State private var currentImage: UIImage?
    @State private var previousImage: UIImage?
    /// So what I'm going to do is, whenever the dark mode is toggled, I will capture the current light mode screen view and store it inthe previos image variable, and I will capture the new state and store it in the current image variable. Once the snapshots have been take, I will use them as an overlay view to smoothly transition from one state to another via the maksing effect.
    @State private var maskAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                BooksView()
                    .setUpTab(.scripture)
                    .opacity(activeTab == .scripture ? 1 : 0)
                
                SettingView()
                    .setUpTab(.setting)
                    .opacity(activeTab == .setting ? 1 : 0)
            }
                .accentColor(activateDarkMode ? .white : .black)
                .createImages(
                    toggleDarkMode: toggleDarkMode,
                    currentImage: $currentImage,
                    previousImage: $previousImage,
                    activeateDarkMode: $activateDarkMode
                )
            
            CustomTabBar()
        }
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
//                if activeTab == .setting {
                if false {
                    Button {
                        toggleDarkMode.toggle()
                    } label: {
                        Image(systemName: toggleDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.title2)
                            .foregroundStyle(Color.primary)
                            .symbolEffect(.bounce, value: toggleDarkMode)
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
            .preferredColorScheme(activateDarkMode ? .dark : .light)
    }
    
    /// Custom Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                    /// iOS 17 allows us to create SF symbols in different ways, such as discreate, indefinite, etc. I'm going to make use of those APIs to create an animated tab bar
                    /// The SF Symbols 5 app allows you to view the animations of the symbols. You can see that there are modification properties for the chosen symbol on the right-hand side. These may be combined to get the desired effect, and once you have it, you can copy the animation and quickly add it to SwiftUI Image using the new SymbolEffect modifier
                    /// The reason why the animation occures twice is that the symbolEffect modifier animates the image when the value changes. To avoid this, we can use Transaction() to tell SwiftUI to disable animation for this particular transaction.
                        .symbolEffect(.bounce.down.byLayer, value: animatedTab.isAnimating)
                    
                    Text(tab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(activeTab == tab ? Color.primary : Color.gray.opacity(0.8))
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    SpeechUtil.share.stopSpeaking()
                    
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                        activeTab = tab
                        animatedTab.isAnimating = true
                    }, completion: {
                        /// As you can notice, the animation is happening only once since we didn't reset the animation status to nil. That's the reason why I wrapped the animation inside the new WithAnimation completion handler, so that I can reset the status to nil once the animation completes.
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }
                    })
                }
            }
        }
        .background(.bar)
    }
}

#Preview {
    CustomTabView()
}
