import UIKit

public class HDAppDelegateHelper: NSObject { }

public extension HDAppDelegateHelper {
    static weak var window: UIWindow?
    
    static func setupForDidFinishLaunching(window: UIWindow?) {
        self.window = window
    }
    
    static func dismissAllDialogViews() {
        guard let subviews = window?.subviews else { return }
        for subview in subviews where subview is HDDialogView {
            if let dialogView = subview as? HDDialogView {
                dialogView.dismiss()
            }
        }
    }
}
