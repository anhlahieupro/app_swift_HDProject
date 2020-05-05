import UIKit

public class HDDatePickerView: HDDialogView {
    @IBOutlet weak var datePicker: UIDatePicker!
    public var completion: (_ date: Date) -> () = { _ in }
    
    public init(maxDate: Date? = nil,
                minDate: Date? = nil,
                currentDate: Date,
                mode: UIDatePicker.Mode) {
        super.init()
        contentView.setCornersRadius(corners: [.topLeft, .topRight], radius: 15)
        datePicker.maximumDate      = maxDate
        datePicker.minimumDate      = minDate
        datePicker.date             = currentDate
        datePicker.datePickerMode   = mode
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func show() {
        showFromBottom()
    }
    
    override public func dismiss() {
        dismissToBottom()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        completion(datePicker.date)
        dismiss()
    }
}
