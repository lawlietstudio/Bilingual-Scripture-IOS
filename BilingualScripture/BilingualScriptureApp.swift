import SwiftUI

@main
struct BilingualScriptureApp: App {
//    @AppStorage("useDarkMode") private var useDarkMode = false
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some Scene {
        WindowGroup {
            CustomTabView()
//                .preferredColorScheme(useDarkMode ? .dark : .light)
//                .accentColor(useDarkMode ? .white : .black)
        }
    }
}
