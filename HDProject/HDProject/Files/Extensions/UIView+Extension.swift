import UIKit

public extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var isShowShadow: Bool {
        set {
            if newValue {
                addShadow(color: .black,
                          shadowOffset: .zero,
                          shadowOpacity: 0.25,
                          shadowRadius: 5)
            } else {
                addShadow(color: .clear,
                          shadowOffset: .zero,
                          shadowOpacity: 0,
                          shadowRadius: 0)
            }
        }
        get {
            return layer.shadowOpacity > 0
        }
    }
    
    func addShadow(color: UIColor = UIColor.black,
                   shadowOffset: CGSize = .zero,
                   shadowOpacity: Float = 0.25,
                   shadowRadius: CGFloat = 5) {
        clipsToBounds       = false
        layer.masksToBounds = false
        layer.shadowColor   = color.cgColor
        layer.shadowOffset  = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius  = shadowRadius
    }
    
    @objc func loadViewFromNibForHDProject() -> UIView {
        guard let bundle = HDUtilities.getHDProjectBundle() else { return UIView() }
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return UIView() }
        return view
    }
    
    @objc func setupNibForHDProject() {
        let view = loadViewFromNibForHDProject()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    @objc func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return UIView() }
        return view
    }
    
    @objc func setupNib() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func addConstraints(equalTo view: UIView,
                        top: CGFloat = 0,
                        bottom: CGFloat = 0,
                        leading: CGFloat = 0,
                        trailing: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
    }
    
    func setCornersRadius(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
