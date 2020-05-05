import UIKit

public extension UITableView {
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections
            && indexPath.row < numberOfRows(inSection: indexPath.section)
    }
    
    func scrollToTop(animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        if hasRowAtIndexPath(indexPath: indexPath) {
            scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
    
    func register(cellIdentifiers: [String]) {
        for cellIdentifier in cellIdentifiers {
            register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        }
    }
    
    func register(headerFooterIdentifiers: [String]) {
        for headerFooterIdentifier in headerFooterIdentifiers {
            register(UINib(nibName: headerFooterIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: headerFooterIdentifier)
        }
    }
    
    func dequeueCell<T: UITableViewCell>(_ Type: T.Type, identifier: String = T.className, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ Type: T.Type, withIdentifier identifier: String = T.className) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T
    }
    
    func cellForRow<T: UITableViewCell>(_ Type: T.Type, at indexPath: IndexPath) -> T? {
        return cellForRow(at: indexPath) as? T
    }
}
