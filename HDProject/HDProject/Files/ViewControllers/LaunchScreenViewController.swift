//
//  LaunchScreenViewController.swift
//  HDProject
//
//  Created by Hieu Dinh on 5/2/20.
//  Copyright © 2020 Hieu Dinh. All rights reserved.
//

import UIKit

public class LaunchScreenViewController: HDBaseViewController {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var icon = ""
    private var titleString = ""
    
    public class func instantiate(icon: String,
                                  titleString: String,
                                  viewDidLoadClosure: @escaping () -> () = { }) -> LaunchScreenViewController? {
        let bundle = HDUtilities.isPod ? HDUtilities.getHDProjectBundle() : nil
        
        let storyboard = UIStoryboard(name: "LaunchScreenViewController", bundle: bundle)
        let viewController = storyboard.instantiate(LaunchScreenViewController.self)
        
        viewController?.icon = icon
        viewController?.titleString = titleString
        viewController?.viewDidLoadClosure = viewDidLoadClosure
        
        return viewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.image = UIImage(named: icon)
        titleLabel.text = titleString
        viewDidLoadClosure()
    }
}
