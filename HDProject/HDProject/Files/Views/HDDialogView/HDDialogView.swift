import UIKit

open class HDDialogView: UIView {
    @IBOutlet weak var contentView: UIView!
    public var willShow: () -> () = { }
    public var willDismiss: () -> () = { }
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        setupViews()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBackgroundColor()
    }
    
    open func setup() {
        HDUtilities.isPod ? setupNibForHDProject() : setupNib()
        updateBackgroundColor()
    }
    
    open func updateBackgroundColor() {
        backgroundColor = UIColor.getOverlayColor(with: traitCollection)
    }
    
    @objc open func show() {
        showFadeIn()
    }
    
    @objc open func dismiss() {
        dismissFadeOut()
    }
}

public extension HDDialogView {
    @objc func setupViews() {
        setup()
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)
    }
}

public extension HDDialogView {
    func addToWindow(completion: () -> ()) {
        guard let window = HDAppDelegateHelper.window else { return }
        window.addSubview(self)
        completion()
    }
    
    func showFadeIn() {
        willShow()
        addToWindow { [weak self] in
            self?.alpha = 1
            self?.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.contentView.transform = CGAffineTransform.identity
            }
        }
    }
    
    func dismissFadeOut() {
        willDismiss()
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.alpha = 0
            self?.contentView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }) { [weak self] (_) in
            self?.removeFromSuperview()
        }
    }
    
    func showFromBottom() {
        willShow()
        addToWindow { [weak self] in
            self?.alpha = 1
            let identity = CGAffineTransform.identity
            let height = self?.contentView.frame.height ?? 0
            self?.contentView.transform = CGAffineTransform.identity.translatedBy(x: identity.tx, y: height)
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.contentView.transform = identity
            }
        }
    }
    
    func dismissToBottom() {
        willDismiss()
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.alpha = 0
            let identity = CGAffineTransform.identity
            let height = self?.contentView.frame.height ?? 0
            self?.contentView.transform = CGAffineTransform.identity.translatedBy(x: identity.tx, y: height)
        }) { [weak self] (_) in
            self?.removeFromSuperview()
        }
    }
    
    func showFromTop() {
        willShow()
        addToWindow { [weak self] in
            self?.alpha = 1
            let identity = CGAffineTransform.identity
            let height = self?.contentView.frame.height ?? 0
            self?.contentView.transform = CGAffineTransform.identity.translatedBy(x: identity.tx, y: -height)
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.contentView.transform = identity
            }
        }
    }
    
    func dismissToTop() {
        willDismiss()
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.alpha = 0
            let identity = CGAffineTransform.identity
            let height = self?.contentView.frame.height ?? 0
            self?.contentView.transform = CGAffineTransform.identity.translatedBy(x: identity.tx, y: -height)
        }) { [weak self] (_) in
            self?.removeFromSuperview()
        }
    }
}

extension HDDialogView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view === contentView)
    }
}
