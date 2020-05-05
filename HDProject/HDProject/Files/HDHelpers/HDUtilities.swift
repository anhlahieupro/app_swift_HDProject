import UIKit

public struct HDUtilities {
    public static var isPod = true
    public static var isShowingForceUpdate = false
}

public extension HDUtilities {
    static func getHDProjectBundle() -> Bundle? {
        let podBundle = Bundle(for: HDBaseViewController.self)
        guard let bundleURL = podBundle.resourceURL?.appendingPathComponent("HDProject.bundle"),
            let bundle = Bundle(url: bundleURL) else { return nil }
        return bundle
    }
}

public extension HDUtilities {
    static func forceHideAds(value: Bool) {
        DispatchQueue.main.async {
            if !value && UserDefaults.isRemovedAds() {
                let messageView = HDMessageView(message: HDStringHelper.showAds) { (_) in }
                messageView.show()
            }
            let refreshAdsSettings = HDNotificationName.refreshAdsSettings
            NotificationCenter.default.post(name: refreshAdsSettings, object: nil)
        }
    }
    
    static func handleForceUpdate(_ forceUpdateToVersion: String) {
        let currentVersion          = Bundle.main.version + "." + Bundle.main.build
        let currentVersionInt       = currentVersion.replacingOccurrences(of: ".", with: "")
        let forceUpdateToVersionInt = forceUpdateToVersion.replacingOccurrences(of: ".", with: "")
        
        showForceUpdateIfNeed(isForceUpdate: currentVersionInt < forceUpdateToVersionInt)
    }
    
    private static func showForceUpdateIfNeed(isForceUpdate: Bool) {
        guard isForceUpdate, !isShowingForceUpdate else { return }
        isShowingForceUpdate = true
        showForceUpdateMessageView()
    }
    
    private static func showForceUpdateMessageView() {
        DispatchQueue.main.async {
            let messageView = HDMessageView(message: HDStringHelper.forceUpdate, noTitle: HDStringHelper.goToAppStore) { (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    HDUtilities.open(urlString: UrlString.hieudinhInAppstore)
                }
            }
            messageView.isAutoDismiss = false
            messageView.show()
        }
    }
}

public extension HDUtilities {
    static func openSettings() {
        HDUtilities.open(urlString: UIApplication.openSettingsURLString)
    }
    
    static func open(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func openMail(sendTo mail: String,
                         subject: String = Bundle.main.appName,
                         body: String = "") {
        let urlString = String(format: "mailto:%@?subject=%@&body=%@", mail, subject, body)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        open(urlString: urlString)
    }
}

public extension HDUtilities {
    static func configureUI() {
        HDUtilities.hideStrangeUnwantedXcodeLogs()
        UIFont.overrideInitialize()
        guard #available(iOS 13.0, *) else { return }
        let window = HDAppDelegateHelper.window
        HDUtilities.configureTheme(window: window)
    }
    
    static func hideStrangeUnwantedXcodeLogs() {
        // Product > Scheme > Edit Scheme
        // OS_ACTIVITY_MODE -> disable
        // Disable autolayout constraint error messages in debug console output in Xcode
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    @available(iOS 13.0, *)
    static func configureTheme(window: UIWindow?, userInterfaceStyle: UIUserInterfaceStyle = .light) {
        window?.overrideUserInterfaceStyle = userInterfaceStyle
    }
}

public extension HDUtilities {
    static func subclasses<T>(of theClass: T) -> [T] {
        var count: UInt32 = 0, result: [T] = []
        let allClasses = objc_copyClassList(&count)!
        for i in 0..<count {
            let someClass: AnyClass = allClasses[Int(i)]
            guard let someSuperClass = class_getSuperclass(someClass),
                String(describing: someSuperClass) == String(describing: theClass) else { continue }
            result.append(someClass as! T)
        }
        return result
    }
}
