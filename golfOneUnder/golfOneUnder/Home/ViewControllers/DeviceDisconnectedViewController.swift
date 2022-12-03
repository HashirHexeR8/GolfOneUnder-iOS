//
//  DeviceDisconnectedViewController.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 12/1/22.
//

import UIKit

class DeviceDisconnectedViewController: UIViewController {

    var onTapConnectDevice: (() -> ())?
    var onTapBack: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        RangeFinderDeviceService.sharedInstance.disconnectDevice()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapDisconnectDevice() {
        dismiss(animated: true)
        onTapConnectDevice!()
    }
    
    @IBAction func onTapBackButton(_ sender: Any) {
        dismiss(animated: true)
        onTapBack!()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
