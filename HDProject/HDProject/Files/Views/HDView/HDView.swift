import UIKit

@IBDesignable open class HDView: UIView {
    private var contentView: UIView?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        HDUtilities.isPod ? setupNibForHDProject() : setupNib()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        let contentView = HDUtilities.isPod ? getViewFromNibForHDProject() : getViewFromNib()
        contentView.prepareForInterfaceBuilder()
    }
}

public extension HDView {
    func getViewFromNibForHDProject() -> UIView {
        let view = loadViewFromNibForHDProject()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        return view
    }
    
    func getViewFromNib() -> UIView {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        return view
    }
}
