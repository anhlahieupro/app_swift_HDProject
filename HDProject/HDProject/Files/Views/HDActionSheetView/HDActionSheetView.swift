import UIKit

public class HDActionSheetView: HDDialogView {
    private var title = ""
    private var actionSheets = [HDActionSheet]()
    public static var isUseSystem = false
    
    public init(title: String, actionSheets: [HDActionSheet]) {
        super.init()
        setup(title: title, actionSheets: actionSheets)
    }
    
    public init(title: String, actionSheets: HDActionSheet...) {
        super.init()
        setup(title: title, actionSheets: actionSheets)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func show() {
        if !HDActionSheetView.isUseSystem {
            showFromBottom()
        } else {
            let alertController = UIAlertController(title: nil,
                                                    message: title,
                                                    preferredStyle: .actionSheet)
            
            for actionSheet in actionSheets {
                let alertAction = UIAlertAction(title: actionSheet.title,
                                                style: actionSheet.style,
                                                handler: { _ in actionSheet.action() })
                alertController.addAction(alertAction)
            }
            
            let viewController = UIApplication.shared.getTopViewController()
            viewController?.present(alertController,
                                    animated: true,
                                    completion: nil)
        }
    }
    
    override public func dismiss() {
        dismissToBottom()
    }
}

public extension HDActionSheetView {
    private func setup(title: String, actionSheets: [HDActionSheet]) {
        self.title = title
        self.actionSheets = actionSheets
        
        contentView.setCornersRadius(corners: [.topLeft, .topRight], radius: 15)
        
        let buttonHeight: CGFloat = 45
        let stackViewSpace: CGFloat = 5
        let bottomPadding: CGFloat = 40
        let count = (title.isEmpty ? 0 : 1) + CGFloat(actionSheets.count)
        let height = buttonHeight * count + stackViewSpace * (count - 1) + bottomPadding
        addConstraintContentView(height: height)
        
        let stackView = createStackView(spacing: stackViewSpace)
        contentView.addSubview(stackView)
        addConstraintStackView(stackView, bottomPadding: -bottomPadding)
        
        addTitle(stackView, title: title)
        addButtons(stackView, actionSheets: actionSheets)
        
        stackView.layoutIfNeeded()
        contentView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    private func addConstraintContentView(height: CGFloat) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func createStackView(spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func addConstraintStackView(_ stackView: UIStackView, bottomPadding: CGFloat) {
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomPadding).isActive = true
    }
    
    private func addTitle(_ stackView: UIStackView, title: String) {
        guard !title.isEmpty else { return }
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 20)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func addButtons(_ stackView: UIStackView, actionSheets: [HDActionSheet]) {
        let textColor = UILabel().textColor
        for actionSheet in actionSheets {
            let button = HDActionButton(frame: .zero)
            button.setTitle(actionSheet.title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.buttonActionTouchUpInside = { actionSheet.action() }
            stackView.addArrangedSubview(button)
        }
    }
}
