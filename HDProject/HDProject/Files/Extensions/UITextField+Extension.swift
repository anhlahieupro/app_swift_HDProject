import UIKit

public extension UITextField {
    func setDoneButtonOnKeyboard(completion: @escaping () -> () = { }) {
        let flexibleSpaceBarButtonItem = HDActionBarButtonItem.initFlexibleSpace()
        let doneAction: () -> () = { [weak self] in
            guard let self = self else { return }
            self.resignFirstResponder()
            completion()
        }
        let doneBarButtonItem = HDActionBarButtonItem(title: HDStringHelper.done, actionBarButtonItem: doneAction)
        let toolBar = HDToolBar(actionBarButtonItems: flexibleSpaceBarButtonItem, doneBarButtonItem)
        inputAccessoryView = toolBar
    }
}
