import UIKit
import FittedSheets

public extension UIViewController {
    static var defaultSheetSizes: [SheetSize] {
        return [.fixed(SettingsTableViewController.defaultHeight), .fullScreen]
    }
    
    @objc func getScreenName() -> String {
        return Bundle.main.appName + " - " + type(of: self).className
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapToViewGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapToViewGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToViewGestureRecognizer)
        
        let tapToNavigationBarGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapToNavigationBarGestureRecognizer.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(tapToNavigationBarGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentSheet(to controller: UIViewController,
                      topCornersRadius: CGFloat = 15,
                      sizes: [SheetSize] = UIViewController.defaultSheetSizes,
                      willDismiss: @escaping () -> () = { }) {
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        sheetController.overlayColor = UIColor.getOverlayColor(with: traitCollection)
        sheetController.topCornersRadius = topCornersRadius
        sheetController.blurBottomSafeArea = false
        sheetController.extendBackgroundBehindHandle = true
        sheetController.willDismiss = { (_) in willDismiss() }
        present(sheetController, animated: false, completion: nil)
    }
}
