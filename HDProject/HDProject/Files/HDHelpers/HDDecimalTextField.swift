import UIKit

public class HDDecimalTextField: UITextField {
    override public func awakeFromNib() {
        super.awakeFromNib()
        keyboardType = .decimalPad
    }
}

public extension HDDecimalTextField {
    private func getNumberString() -> String {
        return getText().replacingOccurrences(of: HDNumberFormatterHelper.getGroupingSeparator(), with: "")
    }
    
    func getText() -> String {
        return text ?? ""
    }
    
    func getNumber() -> Double {
        return HDNumberFormatterHelper.getNumber(string: getNumberString())
    }
    
    func getStringNumber() -> String {
        return HDNumberFormatterHelper.getString(number: getNumber())
    }
    
    func editingChanged() {
        if getText().contains(HDNumberFormatterHelper.getDecimalSeparator()) { return }
        text = getStringNumber()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        let text = getText()
        if text == "0" && string == "0" { return false }
        let decimalSeparator = HDNumberFormatterHelper.getDecimalSeparator()
        if text.isEmpty && string == decimalSeparator { return false }
        if text.contains(decimalSeparator) && string == decimalSeparator { return false }
        let isGreaterThanMaximumFractionDigits = (text.components(separatedBy: decimalSeparator).last?.count ?? 0) >= HDNumberFormatterHelper.maximumFractionDigits
        if text.contains(decimalSeparator) && isGreaterThanMaximumFractionDigits { return false }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        text = getStringNumber()
    }
}
