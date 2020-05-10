import UIKit
import StoreKit
import FittedSheets

public struct UrlString {
    public static let appInAppstore      = String(format: Appstore.itunes, Appstore.appleId)
    public static let hieudinhInAppstore = Appstore.home + Appstore.developer + Appstore.hieudinh

    public static let home               = Website.googleSite + Website.hieudinh
    public static let privatePolicy      = Website.googleSite + Website.hieudinh + Website.privacyPolicy
    public static let termsOfUse         = Website.googleSite + Website.hieudinh + Website.termsOfUse
}

public struct Appstore {
    // TODO: Add AppleId
    public static var appleId   = "1471920386"

    public static let itunes    = "itms-apps://itunes.apple.com/app/apple-store/id%@?mt=8"
    public static let home      = "https://apps.apple.com"
    public static let developer = "/vn/developer"
    public static let hieudinh  = "/hieu-dinh/id1470195666"
}

public struct Website {
    public static let googleSite    = "https://sites.google.com"
    public static let hieudinh      = "/view/hieudinhapp"
    public static let termsOfUse    = "/terms-of-use"
    public static let privacyPolicy = "/privacy-policy"
}

public struct Mail {
    public static let hieudinhapp = "hieudinh.app@gmail.com"
}

private struct SettingIndexPath {
    // Advertisement
    static let removeAds       = IndexPath(row: 0, section: 0)
    static let restorePurchase = IndexPath(row: 1, section: 0)

    // Help
    static let website         = IndexPath(row: 0, section: 1)
    static let termsOfUse      = IndexPath(row: 1, section: 1)
    static let privacyPolicy   = IndexPath(row: 2, section: 1)
    static let feedback        = IndexPath(row: 3, section: 1)

    // Appstore
    static let reviewAndRate   = IndexPath(row: 0, section: 2)
    static let shareToFriends  = IndexPath(row: 1, section: 2)
    static let otherApps       = IndexPath(row: 2, section: 2)

    // Donation
    static let donation        = IndexPath(row: 0, section: 3)
    static let donation2       = IndexPath(row: 1, section: 3)
    static let donation3       = IndexPath(row: 2, section: 3)
}

public class SettingsTableViewController: HDBaseTableViewController {
    @IBOutlet weak var removeLabel: UILabel!
    @IBOutlet weak var restoreLabel: UILabel!
    public static var defaultHeight = UIScreen.main.bounds.height * (3 / 4)
    public static var shareToFriendsText = String(format: "%@\n%@",
                                                  Bundle.main.appName,
                                                  UrlString.appInAppstore)
    
    public static var settingsViewWillAppearClosure:    () -> () = { }
    public static var settingsViewWillDisappearClosure: () -> () = { }
    
    public static var settingsRemoveAdsClosure:         () -> () = { }
    public static var settingsRestorePurchaseClosure:   () -> () = { }
    public static var settingsDonation:                 () -> () = { }
    public static var settingsDonation2:                () -> () = { }
    public static var settingsDonation3:                () -> () = { }
    
    let appInfo = String(format: "%@ - version %@.%@",
                         Bundle.main.appName,
                         Bundle.main.version,
                         Bundle.main.build)
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupRemoveCell()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SettingsTableViewController.settingsViewWillAppearClosure()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SettingsTableViewController.settingsViewWillDisappearClosure()
    }
}

public extension SettingsTableViewController {
    class func show(from baseViewController: HDBaseViewController) {
        presentSettings(from: baseViewController) {
            baseViewController.setupAdsView()
        }
    }
    
    class func show(from baseTableViewController: HDBaseTableViewController) {
        presentSettings(from: baseTableViewController) {
            baseTableViewController.setupAdsView()
        }
    }
    
    private class func presentSettings(from viewController: UIViewController, willDismiss: @escaping () -> ()) {
        guard let controller = SettingsTableViewController.instantiate() else { return }
        viewController.presentSheet(to: controller, willDismiss: willDismiss)
    }
    
    class func instantiate() -> SettingsTableViewController? {
        let bundle = HDUtilities.isPod ? HDUtilities.getHDProjectBundle() : nil
        
        let storyboard = UIStoryboard(name: "SettingsStoryboard", bundle: bundle)
        let storyboardId = String(format: "%@-%@",
                                  SettingsTableViewController.className,
                                  HDStringHelper.language.rawValue)
        
        return storyboard.instantiate(SettingsTableViewController.self,
                                      withIdentifier: storyboardId)
    }
}

// MARK: - Controller
extension SettingsTableViewController {
    public override func refreshAdsSettings() {
        setupRemoveCell()
        adsView.isHidden = UserDefaults.isRemovedAds()
        tableView.reloadData()
    }
}

extension SettingsTableViewController {
    private func setupNavigationController() {
        navigationItem.title = HDStringHelper.settings
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: HDStringHelper.dismiss, style: .plain, target: self, action: #selector(dismiss(animated:completion:)))
    }
    
    private func setupRemoveCell() {
        removeLabel.textColor = UserDefaults.isRemovedAds() ? restoreLabel.textColor?.withAlphaComponent(0.2) : restoreLabel.textColor
        tableView.cellForRow(at: SettingIndexPath.removeAds)?.selectionStyle = UserDefaults.isRemovedAds() ? .none : .default
    }
}

// MARK: - Table View
extension SettingsTableViewController {
    private var numberOfSections: Int {
        // return UserDefaults.isRemovedAds() ? 4 : 5
        return 4
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    override public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footerView = view as? UITableViewHeaderFooterView else { return }
        let pointSize: CGFloat = 15
        footerView.textLabel?.font = .boldSystemFont(ofSize: pointSize)
    }
    
    override public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == numberOfSections - 1 { return appInfo }
        return nil
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
            
        // Advertisement
        case SettingIndexPath.removeAds:        SettingsTableViewController.settingsRemoveAdsClosure()
        case SettingIndexPath.restorePurchase:  SettingsTableViewController.settingsRestorePurchaseClosure()
            
        // Help
        case SettingIndexPath.website:          HDUtilities.open(urlString: UrlString.home)
        case SettingIndexPath.termsOfUse:       HDUtilities.open(urlString: UrlString.termsOfUse)
        case SettingIndexPath.privacyPolicy:    HDUtilities.open(urlString: UrlString.privatePolicy)
        case SettingIndexPath.feedback:         HDUtilities.openMail(sendTo: Mail.hieudinhapp, subject: appInfo)
            
        // Appstore
        case SettingIndexPath.reviewAndRate:    reviewAndRate()
        case SettingIndexPath.shareToFriends:   shareToFriends()
        case SettingIndexPath.otherApps:        HDUtilities.open(urlString: UrlString.hieudinhInAppstore)
            
        // Donation
        case SettingIndexPath.donation:         SettingsTableViewController.settingsDonation()
        case SettingIndexPath.donation2:        SettingsTableViewController.settingsDonation2()
        case SettingIndexPath.donation3:        SettingsTableViewController.settingsDonation3()
        default: break
        }
    }
}

// MARK: - Did Select Cell
extension SettingsTableViewController {
    private func reviewAndRate() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            HDUtilities.open(urlString: UrlString.appInAppstore)
        }
    }
    
    private func shareToFriends() {
        let activityItems = [SettingsTableViewController.shareToFriendsText]
        let activityViewController = UIActivityViewController(activityItems: activityItems,
                                                              applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}
