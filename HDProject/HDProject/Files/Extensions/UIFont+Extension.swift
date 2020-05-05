import UIKit

// MARK: - Configure
//       - add Fonts provided by application (info.plist)
//       - item 0: Quicksand-Regular.ttf
//       - item 1: Quicksand-Bold.ttf

// add: UIFont.overrideInitialize()
// to: AppDelegate
// application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool

// TODO: Add AppFontName
public struct AppFontName {
    public static var regular = "Quicksand-Regular"
    public static var bold    = "Quicksand-Bold"
    public static var italic  = "Quicksand-Regular"
}

public extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

public extension UIFont {
    @objc private class func appSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc private class func appSystemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        if weight == .regular {
            return UIFont(name: AppFontName.regular, size: size)!
        }
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    @objc private class func appBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    @objc private class func appItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.italic, size: size)!
    }
    
    @objc private convenience init(myCoder aDecoder: NSCoder) {
        guard let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = AppFontName.bold
        case "CTFontObliqueUsage":
            fontName = AppFontName.italic
        default:
            fontName = AppFontName.regular
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let appSystemFontMethod = class_getClassMethod(self, #selector(appSystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, appSystemFontMethod)
        }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:weight:))),
            let appSystemFontMethod = class_getClassMethod(self, #selector(appSystemFont(ofSize:weight:))) {
            method_exchangeImplementations(systemFontMethod, appSystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let appBoldSystemFontMethod = class_getClassMethod(self, #selector(appBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, appBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let appItalicSystemFontMethod = class_getClassMethod(self, #selector(appItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, appItalicSystemFontMethod)
        }
        
        // Trick to get over the lack of UIFont.init(coder:))
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
            let appInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, appInitCoderMethod)
        }
        
        // Set font for UI
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
        }
    }
}
