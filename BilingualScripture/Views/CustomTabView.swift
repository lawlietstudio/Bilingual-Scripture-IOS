import SwiftUI

struct CustomTabView: View {
    @State private var activeTab: Int = 0
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
        TabView(selection: $activeTab) {
            BooksView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Scripture")
                }
                .tag(0)

            SettingView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Setting")
                }
                .tag(1)
        }
        .accentColor(activateDarkMode ? .white : .black)
        .createImages(
            toggleDarkMode: toggleDarkMode,
            currentImage: $currentImage,
            previousImage: $previousImage,
            activeateDarkMode: $activateDarkMode
        )
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
            if activeTab == 1 {
                Button {
                    toggleDarkMode.toggle()
                } label: {
                    Image(systemName: toggleDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.title2)
                        .foregroundStyle(Color.primary)
                        .symbolEffect(.bounce, value: toggleDarkMode)
                        .frame(width: 40, height: 40)
                }
                .rect { rect in
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
}

#Preview {
    CustomTabView()
}
