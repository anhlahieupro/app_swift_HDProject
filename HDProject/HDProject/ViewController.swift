//
//  ViewController.swift
//  HDProject
//
//  Created by Hieu Dinh on 11/3/19.
//  Copyright © 2019 Hieu Dinh. All rights reserved.
//

import UIKit

class ViewController: HDBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func action(_ sender: Any) {
//        HDMessageView(confirmMessage: "Message") { (_) in }.show()
        
        SettingsTableViewController.show(from: self)
//        SettingsTableViewController.settingsDonation = { }
//        SettingsTableViewController.settingsDonation2 = { }
//        SettingsTableViewController.settingsDonation3 = { }
//
//        HDActionSheetView.init(title: "hello", actionSheets: HDActionSheet.init(title: "bye", action: {
//            print("bye")
//        })).show()
//
//        HDPickerView.init(pickerModels: [PickerModel.init(title: "cc", data: "cc"),
//                                         PickerModel.init(title: "cc", data: "cc")]).show()
//
//        HDDatePickerView.init(currentDate: Date(), mode: .dateAndTime).show()
    }
}
