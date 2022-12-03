//
//  NotificationViewController.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 12/1/22.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topViewContainer: UIView!

    private var deviceDataSource = OneFinderUserDefaults.sharedInstance.getDeviceList()
    
    var onTapViewLocation: ((_ :DeviceInfoDTO) -> ())?
    var onTapConnectDevice: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topViewContainer.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        topViewContainer.layer.shadowOpacity = 0.5
        topViewContainer.layer.shadowRadius = 1
        topViewContainer.layer.shadowColor = UIColor.black.cgColor
        topViewContainer.layer.cornerRadius = 20
        topViewContainer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onTapConnectDevice(_ sender: Any) {
        dismiss(animated: true)
        onTapConnectDevice!()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationTableViewCell.self)) as! NotificationTableViewCell
        cell.setupCell(deviceInfo: deviceDataSource[indexPath.row], onTapLocation: {
            self.dismiss(animated: true)
            self.onTapViewLocation!(self.deviceDataSource[indexPath.row])
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        deviceDataSource.count
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
