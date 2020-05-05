import UIKit

public class HDPickerView: HDDialogView {
    @IBOutlet weak var pickerView: UIPickerView!
    public var completion: (_ pickerModel: PickerModel) -> () = { _ in }
    
    private var pickerModels: [PickerModel]!
    private var index = 0
    
    public init(pickerModels: [PickerModel], selectedIndex: Int = 0) {
        super.init()
        self.pickerModels = pickerModels
        self.index = selectedIndex
        contentView.setCornersRadius(corners: [.topLeft, .topRight], radius: 15)
        pickerView.reloadAllComponents()
        pickerView.selectRow(index, inComponent: 0, animated: true)
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
        completion(pickerModels[index])
        dismiss()
    }
}

extension HDPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerModels.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerModels[row].title
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        index = row
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}
