import UIKit

public extension UserDefaults {
    static func setAds(isRemoved: Bool) {
        UserDefaults.standard.setValue(isRemoved, forKey: "isRemovedAds")
    }
    
    static func isRemovedAds() -> Bool {
        return UserDefaults.standard.value(forKey: "isRemovedAds") as? Bool ?? false
    }
    
    static func setAdsFromIAP(isRemoved: Bool) {
        UserDefaults.standard.setValue(isRemoved, forKey: "isRemovedAdsFromIAP")
    }
    
    static func isRemovedAdsFromIAP() -> Bool {
        return UserDefaults.standard.value(forKey: "isRemovedAdsFromIAP") as? Bool ?? false
    }
    
    static func setDateOfNumberOfOpenTimes() {
        UserDefaults.standard.setValue(Date(), forKey: "NumberOfOpenTimes")
    }
    
    static func getDateOfNumberOfOpenTimes() -> Date? {
        return UserDefaults.standard.value(forKey: "NumberOfOpenTimes") as? Date
    }
}
