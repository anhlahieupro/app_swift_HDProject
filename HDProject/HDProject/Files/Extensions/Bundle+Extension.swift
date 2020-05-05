import UIKit

public extension Bundle {
    var appName: String {
        let bundleName        = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return bundleName ?? bundleDisplayName ?? "hieudinh.app"
    }
    
    var version: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return version ?? "1.0"
    }
    
    var build: String {
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        return build ?? "0"
    }
}
