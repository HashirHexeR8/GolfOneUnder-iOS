//
//  DiscoverDeviceViewController.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/19/22.
//

import UIKit
import nutble

class DiscoverDeviceViewController: BaseViewController, NTDeviceManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var devicesTableView: UITableView!
    
    private var devicesDataSource: [NTDevice]! = []
    
    var onDeviceConnted: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: String(describing: DeviceTableViewCell.self), bundle: nil)
        devicesTableView.register(nib, forCellReuseIdentifier: String(describing: DeviceTableViewCell.self))
        devicesTableView.delegate = self
        devicesTableView.dataSource = self
        NTDeviceManager.shared().delegate = self
        NTDeviceManager.shared().startScan()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceConnectionSuccess), name: Constants.deviceConnectionSuccessNotifName, object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func deviceConnectionSuccess() {
        self.dismiss(animated: true)
        onDeviceConnted!()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DeviceTableViewCell.self)) as! DeviceTableViewCell
        cell.deviceNameLabel.text = devicesDataSource[indexPath.row].localName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.devicesDataSource[indexPath.row].connect()
        self.devicesDataSource[indexPath.row].delegate = RangeFinderDeviceService.sharedInstance
    }
    
    func deviceManager(_ manager: NTDeviceManager!, didUpdate state: CBCentralManagerState) {
        print("\(state)")
    }
    
    func deviceManager(_ manager: NTDeviceManager!, didDiscoveredDevice device: NTDevice!, rssi: NSNumber!) {
        DispatchQueue.main.async {
            self.devicesDataSource.append(device)
            self.devicesTableView.reloadData()
        }
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
