import UIKit

public extension String {
    var attributedString: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    var mutableAttributedString: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
    
    func toDate(format: DateFormatStyle = .MMddyyyy) -> Date? {
        return DateFormatter.getDate(format: format, string: self)
    }
    
    func toDate(format: String = DateFormatStyle.MMddyyyy.rawValue) -> Date? {
        return DateFormatter.getDate(format: format, string: self)
    }
    
    func convertBase64ToImage() -> UIImage? {
        guard let imageData = Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) else { return nil }
        return UIImage(data: imageData)
    }
}
