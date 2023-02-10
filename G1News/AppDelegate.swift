import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.coordinateSpace.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: FeedViewController(viewModel: .init()))
        
        registerForPushNotifications()
        
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                    guard granted else { return }
                    self?.getNotificationSettings()
                }
        
        return true
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in

            let viewAction = UNNotificationAction(
              identifier: "Identifiers",
              title: "View",
              options: [.foreground])

            let newsCategory = UNNotificationCategory(
              identifier: "Identifiers_Notifications",
              actions: [viewAction],
              intentIdentifiers: [],
              options: [])

            UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
        }
    }

}

