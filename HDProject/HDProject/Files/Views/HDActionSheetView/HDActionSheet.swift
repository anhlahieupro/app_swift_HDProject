public struct HDActionSheet {
    public var title: String!
    public typealias ActionSheetAction = () -> ()
    public var action: ActionSheetAction = { }
    
    public init(title: String, action: @escaping ActionSheetAction) {
        self.title = title
        self.action = action
    }
}
