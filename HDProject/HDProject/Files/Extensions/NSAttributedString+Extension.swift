import UIKit

public extension NSAttributedString {
    func add(_ attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        let range = NSRange(location: 0, length: string.count)
        mutableAttributedString.addAttributes(attributes, range: range)
        return mutableAttributedString
    }
    
    func font(_ font: UIFont) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font: font]
        return add(attributes)
    }
    
    func color(_ color: UIColor) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        return add(attributes)
    }
    
    func background(color: UIColor) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.backgroundColor: color]
        return add(attributes)
    }
    
    func textAlignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraph]
        return add(attributes)
    }
    
    func lineSpacing(lineSpacing: CGFloat = 0,
                     lineHeightMultiple: CGFloat = 0) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return add(attributes)
    }
}

public extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .bold)]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text: String, size: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .regular)]
        let normalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(normalString)
        return self
    }
}
