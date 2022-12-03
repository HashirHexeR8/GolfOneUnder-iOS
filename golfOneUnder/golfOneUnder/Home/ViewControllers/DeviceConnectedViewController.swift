//
//  DeviceConnectedViewController.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/30/22.
//

import Foundation
import UIKit

class DeviceConnectedViewController: UIViewController {
    
    @IBOutlet weak var deviceNameLabelContainer: UIView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    var didTapTrackLocation: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        deviceNameLabelContainer.layer.cornerRadius = 5.0
        deviceNameLabel.text = RangeFinderDeviceService.sharedInstance.getConnectedDevice()?.localName
    }
    
    @IBAction func onTapTrackLocation(_ sender: Any) {
        self.dismiss(animated: true)
        didTapTrackLocation!()
    }
}
