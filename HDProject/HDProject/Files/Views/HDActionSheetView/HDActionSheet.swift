import UIKit

public struct HDActionSheet {
    public var title = ""
    public var style = UIAlertAction.Style.default
    public var action: () -> () = { }
    
    public init(title: String,
                style: UIAlertAction.Style = .default,
                action: @escaping () -> ()) {
        self.title = title
        self.style = style
        self.action = action
    }
}
