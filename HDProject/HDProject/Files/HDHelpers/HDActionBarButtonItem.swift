import UIKit

public class HDActionBarButtonItem: UIBarButtonItem {
    public typealias ToolBarAction = () -> ()
    public var toolBarAction: ToolBarAction = { }
    
    init(title: String, actionBarButtonItem: @escaping ToolBarAction) {
        super.init()
        self.title  = title
        self.style  = .plain
        self.target = self
        self.action = #selector(barButtonItemAction)
        self.toolBarAction = actionBarButtonItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension HDActionBarButtonItem {
    static func initFlexibleSpace() -> UIBarButtonItem {
        let item = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        return item
    }
    
    @objc func barButtonItemAction() {
        toolBarAction()
    }
}
