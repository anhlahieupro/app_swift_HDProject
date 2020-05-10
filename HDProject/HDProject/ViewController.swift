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
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        HDAppDelegateHelper.setupForDidFinishLaunching(window: appDelegate?.window)
    }
    
    @IBAction func action(_ sender: Any) {
        //        HDMessageView(confirmMessage: "Message", yesTitle: "OK", noTitle: "Dismiss") { (_) in
        //            print("Message")
        //        }.show(isUseSystem: false)
        
        //        HDActionSheetView(title: "Message", actionSheets: HDActionSheet(title: "HDActionSheet", action: {
        //
        //        }), HDActionSheet(title: "Dismiss", style: .cancel, action: {
        //
        //        })).show(isUseSystem: false)
        
        //        HDMessageView(confirmMessage: "Message") { (_) in }.show()
        
        //        SettingsTableViewController.show(from: self)
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
