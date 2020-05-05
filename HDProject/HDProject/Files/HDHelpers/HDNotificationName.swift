import UIKit

public struct HDNotificationKey {
    public static let refreshAdsSettings = "refreshAdsSettings"
}

public struct HDNotificationName {
    public static let refreshAdsSettings = Notification.Name(rawValue: HDNotificationKey.refreshAdsSettings)
}
