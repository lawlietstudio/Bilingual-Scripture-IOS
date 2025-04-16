import SwiftUI
import FirebaseCore
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UserDefaults.standard.setValue(true, forKey: "FIRDebugEnabled")
        UserDefaults.standard.setValue(true, forKey: "FIRAnalyticsDebugEnabled")
        UserDefaults.standard.set(true, forKey: "/google/firebase/debug_mode")
        UserDefaults.standard.set(true, forKey: "/google/measurement/debug_mode")

        
        FirebaseApp.configure()
        
        // Optional test event
        Analytics.logEvent("test_event", parameters: [
            "time": "\(Date())"
        ])
        
        return true
    }
}

@main
struct BilingualScriptureApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var speechViewModel = SpeechViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            CustomTabView()
                .environmentObject(speechViewModel)
                .environmentObject(settingsViewModel)
        }
    }
}
